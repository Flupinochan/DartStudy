import 'package:fifth_app/data/dummy_data.dart';
import 'package:fifth_app/models/meal.dart';
import 'package:fifth_app/screens/categories.dart';
import 'package:fifth_app/screens/filters.dart';
import 'package:fifth_app/screens/meals.dart';
import 'package:fifth_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kInitialFilters = {
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
  Filters.vegetarian: false,
  Filters.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  // お気に入りリストは、上位のTabScreenで管理
  final List<Meal> _favoriteMeals = [];
  Map<Filters, bool> _selectedFilters = kInitialFilters;

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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // 遷移先でpopする際の引数をresultで受け取る ※pushのみでpushReplacementでは受け取れない
      final result = await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(builder: (ctx) => FiltersScreen(_selectedFilters)),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals =
        dummyMeals.where((meal) {
          if (_selectedFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
            return false;
          }
          if (_selectedFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
            return false;
          }
          if (_selectedFilters[Filters.vegetarian]! && !meal.isVegetarian) {
            return false;
          }
          if (_selectedFilters[Filters.vegan]! && !meal.isVegan) {
            return false;
          }
          return true;
        }).toList();

    Widget activePage = CategoriesScreen(
      availableMeals,
      _toggleMealFavoriteStatus,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Favorites';
    }

    // PopScopeで戻るボタンを押した際の動作を変更可能
    // アプリ終了確認ボタンを表示する
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text('終了確認', style: TextStyle(color: Colors.white)),
                content: Text(
                  'アプリを終了してもよろしいですか？',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    child: Text('キャンセル', style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                  TextButton(
                    child: Text('終了', style: TextStyle(color: Colors.white)),
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(activePageTitle)),
        body: activePage,
        drawer: MainDrawer(onSelectedScreen: _setScreen),
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
      ),
    );
  }
}
