import 'package:flutter/material.dart';
import 'package:kickexchange/models/navigation_model.dart';
import 'package:kickexchange/views/add_product_page.dart';
import 'package:kickexchange/views/edit_product_page.dart';
import 'package:kickexchange/views/homepage.dart';
import 'package:kickexchange/views/profile_page.dart';
import 'package:kickexchange/views/search_product_page.dart';

class NavigationProvider with ChangeNotifier {
  List<NavigationModel> items = [
    NavigationModel(label: "Home", widget: Homepage(), iconData: Icons.home),
    NavigationModel(
        label: "Search", widget: SearchProductPage(), iconData: Icons.search),
    NavigationModel(
        label: "Add", widget: AddProductPage(), iconData: Icons.add),
    NavigationModel(
        label: "Edit", widget: EditProductPage(), iconData: Icons.edit),
    NavigationModel(
        label: "Profile", widget: ProfilePage(), iconData: Icons.person),
  ];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}
