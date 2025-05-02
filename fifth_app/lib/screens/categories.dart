import 'package:fifth_app/models/category.dart';
import 'package:fifth_app/models/meal.dart';
import 'package:fifth_app/screens/meals.dart';
import 'package:fifth_app/widgets/category_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:fifth_app/data/dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(this.onToggleFavorite, {super.key});

  final void Function(Meal meal) onToggleFavorite;

  // Navigator push でWidgetを遷移したら、自動的にappBarに←Buttonが追加される
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals =
        dummyMeals
            .where((meal) => meal.categories.contains(category.id))
            .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (ctx) => MealsScreen(
              title: category.title,
              meals: filteredMeals,
              onToggleFavorite: onToggleFavorite,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(category, () {
            _selectCategory(context, category);
          }),
      ],
    );
  }
}
