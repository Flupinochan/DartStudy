import 'package:fifth_app/screens/tabs.dart';
import 'package:fifth_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutennFreeFilterSet = false;

  @override
  Widget build(BuildContext context) {
    // Scaffoldは、各画面共通の構造(スケルトン)の1つであり、一択
    // appBarやdrawerなどが付属していて便利
    return Scaffold(
      appBar: AppBar(title: const Text('Filters')),
      // drawerを配置すると戻るbuttonと置き換わる
      drawer: MainDrawer(
        onSelectedScreen: (identifier) {
          Navigator.of(context).pop();
          if (identifier == 'meals') {
            // pushとpushReplacementの違いとしては、戻ることが可能かどうか
            // Sidebar(drawer)には戻らなくてよい
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => TabsScreen()),
            );
          }
        },
      ),
      body: Column(
        children: [
          // on/off切り替え機能付きのListItem
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
        ],
      ),
    );
  }
}
