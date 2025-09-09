import 'package:currency_tracker/core/di/injector.dart';
import 'package:currency_tracker/core/theme/theme_controller.dart';
import 'package:currency_tracker/presentation/pages/currency_converter_page.dart';
import 'package:currency_tracker/presentation/pages/currency_list_page.dart';
import 'package:currency_tracker/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = injector.get<HomeViewController>();
    final themeController = injector.get<ThemeController>();

    final pages = [
      const CurrencyListPage(),
      const CurrencyConverterPage(),
    ];

    return Watch(
      (_) {
        final index = controller.selectedIndex.value;
        return Scaffold(
          appBar: AppBar(
            title: Watch(
              (_) => Text(index == 0 ? 'Moedas' : 'Conversão'),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              Watch(
                (_) => Switch(
                  value: !themeController.isLightMode.value,
                  onChanged: (_) => themeController.toggleTheme(),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          body: pages[index],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Moedas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange),
                label: 'Conversão',
              ),
            ],
            currentIndex: index,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: controller.changeTab,
          ),
        );
      },
    );
  }
}
