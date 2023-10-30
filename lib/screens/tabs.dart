import 'package:first_app/data/dummy_data.dart';
import 'package:first_app/models/meal.dart';
import 'package:first_app/screens/categories.dart';
import 'package:first_app/screens/filters.dart';
import 'package:first_app/screens/meals.dart';
import 'package:first_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    setState(() {
      if (_favoriteMeals.contains(meal)) {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Favorite removed.');
      } else {
        _favoriteMeals.add(meal);
        _showInfoMessage('Favorite added!');
      }
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? _selectedFilters;
      });
    }
  }

  List<Meal> get _availableMeals {
    final isGlutenFreeChecked = _selectedFilters[Filter.glutenFree] ?? false;
    final isLactoseFreeChecked = _selectedFilters[Filter.lactoseFree] ?? false;
    final isVegetarianChecked = _selectedFilters[Filter.vegetarian] ?? false;
    final isVeganChecked = _selectedFilters[Filter.vegan] ?? false;

    return dummyMeals.where(
      (meal) {
        if (isGlutenFreeChecked && !meal.isGlutenFree) return false;
        if (isLactoseFreeChecked && !meal.isLactoseFree) return false;
        if (isVegetarianChecked && !meal.isVegetarian) return false;
        if (isVeganChecked && !meal.isVegan) return false;
        return true;
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: _availableMeals,
    );
    String activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Your Favorites';
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
