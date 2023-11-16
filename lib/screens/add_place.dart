import 'package:first_app/models/place.dart';
import 'package:first_app/providers/places_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _placeName;

  void _onBack(context) {
    Navigator.pop(context);
  }

  void _onSubmit() {
    _formKey.currentState!.save();

    if (_placeName == null || _placeName!.isEmpty) {
      return;
    }

    ref.read(placesListProvider.notifier).addPlace(Place(title: _placeName!));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
        // automaticallyImplyLeading: true,
        leading: Builder(
          builder: (context) => BackButton(
            onPressed: () {
              _onBack(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                    decorationThickness: 0,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onSaved: (newValue) {
                    _placeName = newValue;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the place name';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          _onSubmit();
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.add), Text('Add Place')],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
