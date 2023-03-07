import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/checkout_page/enter_delivery_details_page.dart';
import 'package:blackmarket_app/injector.dart';

import '../widgets/loading_indicator.dart';
import 'checkout_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({ Key? key, required this.product }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();


  final Product product;
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutPageController>(
      create: (context) {        
        return CheckoutPageController(widget.product.id, context: context)..initialize();
      },
      child: Scaffold(body: _buildMain())
    );
  }

  Widget _buildMain() {    
    return Consumer<CheckoutPageController>(
      builder: (context, value, child) {
        if(value.isLoading)
          return const LoadingIndicator();

        return Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => const EnterDeliveryDetailsPage());
          },
          initialRoute: 'Enter Address Page'
        );
      }
    );
  }
}