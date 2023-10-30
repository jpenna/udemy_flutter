import 'package:first_app/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final filters = ref.watch(filtersProvider);
  final meals = ref.watch(mealsProvider);

  final isGlutenFreeChecked = filters[Filter.glutenFree] ?? false;
  final isLactoseFreeChecked = filters[Filter.lactoseFree] ?? false;
  final isVegetarianChecked = filters[Filter.vegetarian] ?? false;
  final isVeganChecked = filters[Filter.vegan] ?? false;

  return meals.where(
    (meal) {
      if (isGlutenFreeChecked && !meal.isGlutenFree) return false;
      if (isLactoseFreeChecked && !meal.isLactoseFree) return false;
      if (isVegetarianChecked && !meal.isVegetarian) return false;
      if (isVeganChecked && !meal.isVegan) return false;
      return true;
    },
  ).toList();
});
