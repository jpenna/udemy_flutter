import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/grocery_list_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future _loadItems() async {
    try {
      final response = await http.get(
        Uri.https(
          'flutter-test-68777-default-rtdb.firebaseio.com',
          'shopping-list.json',
        ),
      );

      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Try again later";
          _isLoading = false;
        });
        return;
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);

      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final value = item.value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: value['name'],
            quantity: value['quantity'],
            category: categories.entries
                .firstWhere(
                    (element) => element.value.name == value['category'])
                .value,
          ),
        );
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = "Ops! Failed to fetch!";
        _isLoading = false;
      });
    }
  }

  void _addItem(BuildContext context) async {
    GroceryItem? item = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (ctx) => const NewItem()),
    );
    if (item == null) {
      return;
    }

    setState(() {
      _groceryItems.add(item);
    });
  }

  void _showFailedToDeleteMessage() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Failed to delete grocery.'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _removeItem(GroceryItem item, int index) async {
    setState(() {
      _groceryItems.removeAt(index);
    });

    final response = await http.delete(
      Uri.https(
        'flutter-test-68777-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json',
      ),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
      _showFailedToDeleteMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    } else {
      content = _groceryItems.isEmpty
          ? const Center(
              child: Text('Your list is empty. Add new items to your list.'),
            )
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) =>
                  GroceryListItem(_groceryItems[index], index, _removeItem),
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: () {
              _addItem(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
