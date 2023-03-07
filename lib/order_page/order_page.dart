import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/product_page/images_carousel/images_carousel.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_indicator.dart';
import 'order_page_controller.dart';
import 'order_progress_stepper.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(this.product, { Key? key }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();


  final String product;
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {    
    super.initState();

    _controller = OrderPageController(widget.product);    
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderPageController>(
      create: (context) => _controller..initialize(),
      child: Consumer<OrderPageController>(
        builder: (context, value, child) {
          return Scaffold(appBar: _buildAppBar(), body: _buildBody());
        }        
      )
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(title: const Text('Order Details'));

  Widget _buildBody() {
    if(_controller.isLoading)
      return const LoadingIndicator();

    final ThemeData theme = Theme.of(context);

    final Order order = _controller.order!; 

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 320.0,
            child: ImagesCarousel(product: order.product)
          ),
          
          const SizedBox(height: 32.0),

          _buildTitle(),

          const SizedBox(height: 16.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildPriceDetails(theme),

                    _buildSoldByDetails(theme)                    
                  ]
                ),

                OrderProgressStepper(order)
              ]
            )
          )
        ]
      )
    );
  }

  Widget _buildPriceDetails(final ThemeData theme) {
    final Order order = _controller.order!;

    return Text('Rs ${order.amount}', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary));
  }

  Widget _buildSoldByDetails(final ThemeData theme) {
    final Order order = _controller.order!; 

    return RichText(
      text: TextSpan(
        text: 'Sold by:',
        style: theme.textTheme.bodyMedium,
        children: <TextSpan>[
          TextSpan(text: ' ${order.product.seller.username}', style: theme.textTheme.headline6)
        ]
      )
    );
  }

  Widget _buildTitle() {
    final ThemeData theme = Theme.of(context);

    final Order order = _controller.order!;

    return SizedBox(
      height: 40.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Marquee(
            text: order.product.name.toUpperCase(),
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

  late final OrderPageController _controller;
}