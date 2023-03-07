import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../injector.dart';

class YourItemsPageController extends ChangeNotifier {
  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    soldItems = await _inventory.getAllSellersProducts();
    isLoading = false;
    notifyListeners();
  }



  bool isLoading = true;
  List<SoldItem>? soldItems;
  final Inventory _inventory = getIt<Client>().inventory();
}