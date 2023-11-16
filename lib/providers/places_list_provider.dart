import 'package:first_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListNotifier extends StateNotifier<List<Place>> {
  PlacesListNotifier() : super(const []);

  void addPlace(Place place) {
    state = [...state, place];
  }
}

final placesListProvider =
    StateNotifierProvider.autoDispose<PlacesListNotifier, List<Place>>((ref) {
  return PlacesListNotifier();
});
