import 'package:first_app/providers/filters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(filtersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Filters')),
      body: Column(
        children: [
          _FilterToggle(
            'Gluten-free',
            'Only include gluten-free meals.',
            Filter.glutenFree,
            filters[Filter.glutenFree]!,
          ),
          _FilterToggle(
            'Lactose-free',
            'Only include lactose-free meals.',
            Filter.lactoseFree,
            filters[Filter.lactoseFree]!,
          ),
          _FilterToggle(
            'Vegetarian',
            'Only include vegetarian meals.',
            Filter.vegetarian,
            filters[Filter.vegetarian]!,
          ),
          _FilterToggle(
            'Vegan',
            'Only include vegan meals.',
            Filter.vegan,
            filters[Filter.vegan]!,
          ),
        ],
      ),
    );
  }
}

class _FilterToggle extends ConsumerWidget {
  const _FilterToggle(
    this.label,
    this.subtitle,
    this.filterKey, [
    this.value = false,
  ]);

  final String label;
  final String subtitle;
  final Filter filterKey;
  final bool value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggler = ref.read(filtersProvider.notifier).setFilter;

    return SwitchListTile(
      value: value,
      onChanged: (isChecked) {
        toggler(filterKey, isChecked);
      },
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(left: 34, right: 22),
    );
  }
}
