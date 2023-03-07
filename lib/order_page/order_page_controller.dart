import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../injector.dart';

class OrderPageController extends ChangeNotifier {
  OrderPageController(this.product);

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    order = await _orderServices.getOrderForProduct(product);
    isLoading = false;
    notifyListeners();
  }
  

  bool isLoading = true;  

  Order? order;

  final String product;

  final OrderServices _orderServices = getIt<Client>().orderServices();
}