import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem(this.item, this.index, this.removeItem, {super.key});

  final GroceryItem item;
  final int index;
  final void Function(GroceryItem item, int index) removeItem;

  void _deleteItem(direction) {
    removeItem(item, index);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(color: Colors.red),
      onDismissed: _deleteItem,
      child: ListTile(
        title: Text(item.name),
        leading: Container(
          height: 24,
          width: 24,
          color: item.category.color,
        ),
        trailing: Text(item.quantity.toString()),
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       ColoredBox(
    //         color: item.category.color,
    //         child: const SizedBox.square(
    //           dimension: 20,
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 20,
    //       ),
    //       Text(item.name),
    //       const Spacer(),
    //       Text(item.quantity.toString()),
    //     ],
    //   ),
    // );
  }
}
