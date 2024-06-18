import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/navigation_provider.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/models/navigation_model.dart';
import 'package:provider/provider.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<NavigationProvider>(context);
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return navigationProvider
              .items[navigationProvider.selectedIndex].widget!;
        },
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return NavigationBar(
            backgroundColor: AppColors.white,
            indicatorColor: AppColors.orange,
            selectedIndex: navigationProvider.selectedIndex,
            onDestinationSelected: (int index) {
              navigationProvider.selectedIndex = index;
            },
            destinations: navigationProvider.items.asMap().entries.map((entry) {
              int idx = entry.key;
              NavigationModel item = entry.value;
              Color iconColor = navigationProvider.selectedIndex == idx
                  ? Colors.white
                  : Colors.black;

              return NavigationDestination(
                icon: Icon(item.iconData, color: iconColor),
                label: item.label!,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
