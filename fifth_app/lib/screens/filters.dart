// import 'package:fifth_app/screens/tabs.dart';
// import 'package:fifth_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

enum Filters { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersScreen extends StatefulWidget {
  const FiltersScreen(this.filters, {super.key});

  final Map<Filters, bool> filters;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutennFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFilterSet = false;
  var _veganFilterSet = false;

  @override
  void initState() {
    super.initState();
    _glutennFreeFilterSet = widget.filters[Filters.glutenFree]!;
    _lactoseFreeFilterSet = widget.filters[Filters.lactoseFree]!;
    _vegetarianFilterSet = widget.filters[Filters.vegetarian]!;
    _veganFilterSet = widget.filters[Filters.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    // Scaffoldは、各画面共通の構造(スケルトン)の1つであり、一択
    // appBarやdrawerなどが付属していて便利
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 戻る操作が発生したときに値を返す
          Navigator.of(context).pop({
            Filters.glutenFree: _glutennFreeFilterSet,
            Filters.lactoseFree: _lactoseFreeFilterSet,
            Filters.vegetarian: _vegetarianFilterSet,
            Filters.vegan: _veganFilterSet,
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Filters')),
        // drawerを配置すると戻るbuttonと置き換わる
        // drawer: MainDrawer(
        //   onSelectedScreen: (identifier) {
        //     // popに引数を渡すと、このwidget呼び出し元に値を渡せる
        //     // ※WPFのDialogResultと同じ
        //     Navigator.of(context).pop({
        //       Filters.glutenFree: _glutennFreeFilterSet,
        //       Filters.lactoseFree: _lactoseFreeFilterSet,
        //       Filters.vegetarian: _vegetarianFilterSet,
        //       Filters.vegan: _veganFilterSet,
        //     });
        //     if (identifier == 'meals') {
        //       // pushとpushReplacementの違いとしては、戻ることが可能かどうか
        //       // Sidebar(drawer)には戻らなくてよい
        //       Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (ctx) => TabsScreen()),
        //       );
        //     }
        //   },
        // ),
        body: Column(
          children: [
            // on/off切り替え機能(toggle button)付きのListItem
            SwitchListTile(
              value: _glutennFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _glutennFreeFilterSet = isChecked;
                });
              },
              title: Text('Gluten-free'),
              subtitle: Text('Only include gluten-free meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _lactoseFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _lactoseFreeFilterSet = isChecked;
                });
              },
              title: Text('Lactose-free'),
              subtitle: Text('Only include lactose-free meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _vegetarianFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _vegetarianFilterSet = isChecked;
                });
              },
              title: Text('Vegetarian'),
              subtitle: Text('Only include vegetarian meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _veganFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _veganFilterSet = isChecked;
                });
              },
              title: Text('Vegan'),
              subtitle: Text('Only include vegan meals.'),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
