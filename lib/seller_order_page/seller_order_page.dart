import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:blackmarket_app/product_page/images_carousel/images_carousel.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../widgets/loading_indicator.dart';
import 'order_progress_stepper.dart';

class SellerOrderPage extends StatefulWidget {
  const SellerOrderPage(this.product, { Key? key }) : super(key: key);

  @override
  State<SellerOrderPage> createState() => _SellerOrderPageState();


  final String product;
}

class _SellerOrderPageState extends State<SellerOrderPage> {
  @override
  void initState() {
    super.initState();

    Future<void>(
      () async {
        final Order order = await _orderServices.getOrderForProduct(widget.product);

        setState(
          () {
            _order = order;
            _isLoading = false;
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() => AppBar(title: const Text('Order Details'));

  Widget _buildBody() {
    if(_isLoading)
      return const LoadingIndicator();
          
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 320.0,
            child: ImagesCarousel(product: _order.product)
          ),
          
          const SizedBox(height: 32.0),

          _buildTitle(),

          const SizedBox(height: 16.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'Purchased by:',
                    style: theme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(text: ' ${_order.purchasedBy.username}', style: theme.textTheme.headline6)
                    ]
                  )
                ),

                OrderProgressStepper(_order)
              ]
            )
          )
        ]
      )
    );
  }

  Widget _buildTitle() {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: 40.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Marquee(
            text: _order.product.name.toUpperCase(),
            style: theme.textTheme.headline5,
            pauseAfterRound: const Duration(milliseconds: 5000),
            blankSpace: constraints.maxWidth,
            velocity: 200.0,
            startPadding: 16.0,
          );
        }
      )
    );
  }


  bool _isLoading = true;  

  late final Order _order;

  final OrderServices _orderServices = getIt<Client>().orderServices();
}