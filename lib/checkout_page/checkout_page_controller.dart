import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:blackmarket_app/order_page/order_page.dart';
import 'complete_checkout.dart';
import 'package:flutter/material.dart';

class CheckoutPageController extends ChangeNotifier {
  CheckoutPageController(this.product, {required this.context});

  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    order = await _orderServices.getOrderForProduct(product);    
    isLoading = false;
    notifyListeners();
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  void setDeliveryDetails(final Address address, final String contactNumber) {
    _address = address;
    _contactNumber = contactNumber;
    notifyListeners();
  }

  Future<void> confirmButtonOnClicked(final BuildContext pageContext) async {
    final Order order = this.order!;
    final CompleteCheckout completeCheckout = new CompleteCheckout(order, address!, contactNumber!);
    try {
      await completeCheckout.completeCheckout();
    }
    on Exception catch(e) {
      print('Checkout Failed - $e');

      final ThemeData theme = Theme.of(pageContext);
      SnackBar snackBar = SnackBar(
        content: Text(
          'Checkout Failed!', 
          style: TextStyle(color: theme.colorScheme.error)
        )
      );
      ScaffoldMessenger.of(pageContext).showSnackBar(snackBar);
      return;
    }

    final MaterialPageRoute route = MaterialPageRoute(builder: (context) => OrderPage(order.product.id));
    Navigator.of(context).pushReplacement(route);
  }

  Address? get address => _address;

  String? get contactNumber => _contactNumber;


  Address? _address;
  String? _contactNumber;

  final String product;
  Order? order;

  bool isLoading = true;

  final OrderServices _orderServices = getIt<Client>().orderServices();

  final BuildContext context;
}