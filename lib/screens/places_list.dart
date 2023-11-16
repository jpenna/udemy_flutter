import 'package:first_app/models/place.dart';
import 'package:first_app/providers/places_list_provider.dart';
import 'package:first_app/screens/add_place.dart';
import 'package:first_app/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({super.key});

  void _onAddNewPlace(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlaceScreen(),
      ),
    );
  }

  void _openDetailsScreen(BuildContext context, Place place) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PlaceDetailsScreen(place)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> placesList = ref.watch(placesListProvider);

    final content = placesList.isEmpty
        ? Center(
            child: Text(
              'No places added yet.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          )
        : ListView.builder(
            itemCount: placesList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                _openDetailsScreen(context, placesList[index]);
              },
              title: Text(
                placesList[index].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () => _onAddNewPlace(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
