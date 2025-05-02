import 'package:fifth_app/models/meal.dart';
import 'package:fifth_app/screens/categories.dart';
import 'package:fifth_app/screens/filters.dart';
import 'package:fifth_app/screens/meals.dart';
import 'package:fifth_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  // お気に入りリストは、上位のTabScreenで管理
  final List<Meal> _favoriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Removed from favorites.');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as favorite!');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => FiltersScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(_toggleMealFavoriteStatus);
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      body: activePage,
      // appBarと同様に、sideBarを表示したい場合
      drawer: MainDrawer(onSelectedScreen: _setScreen),
      // appBarと同様に、下部にメニューバーを表示したい場合
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        // 選択されているitemsの要素を指定
        currentIndex: _selectedPageIndex,
        items: [
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
