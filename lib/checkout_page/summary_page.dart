import 'package:blackmarket_app/product_page/images_carousel/images_carousel.dart';
import 'package:flutter/material.dart';
import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'checkout_page_controller.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({ Key? key }) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();  
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar: _buildAppBar(), body: _buildBody()));
  }

  PreferredSizeWidget _buildAppBar() => AppBar(title: const Text("Checkout Summary"));

  Widget _buildBody() {
    final ThemeData theme = Theme.of(context);
    
    final CheckoutPageController controller = Provider.of<CheckoutPageController>(context, listen: false);
    final Order order = controller.order!;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 320.0,
                  child: ImagesCarousel(product: order.product)
                ),

                const SizedBox(height: 32.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        child: Marquee(
                          text: order.product.name.toUpperCase(),
                          style: theme.textTheme.headline5,
                          pauseAfterRound: const Duration(milliseconds: 5000)
                        ),
                      ),

                      _buildSizeInfo(),

                      const SizedBox(height: 16.0),

                      Text(order.product.description),

                      const SizedBox(height: 32.0),

                      _buildAddressArea(order)
                    ]
                  ),
                ),

                const SizedBox(height: 16.0)
              ]
            )
          )
        ),

        const SizedBox(height: 16.0),

        _buildBottomArea(order)
      ]
    );
  }  

  Widget _buildSizeInfo() {
    final ThemeData theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: 'Size:',
        style: theme.textTheme.bodyText2,
        children: <TextSpan>[
          TextSpan(text: ' 10', style: theme.textTheme.headline6)
        ]
      )
    );
  }    

  Widget _buildAddressArea(final Order order) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Delivery Address', style: theme.textTheme.headline6),
        
        const SizedBox(height: 8.0),

        Text(order.deliverTo)
      ]
    );
  }

  Widget _buildBottomArea(final Order order) {
    final ThemeData theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: new BoxDecoration(
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16.0)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: 'Checkout Price:',
                  style: theme.textTheme.bodyText2,
                  children: <TextSpan>[
                    TextSpan(text: ' ${order.amount}', style: theme.textTheme.headline6)
                  ]
                )
              ),

              _buildPayButton()
            ]
          )
        )
      )
    );
  }

  Widget _buildPayButton() {
    final ThemeData theme = Theme.of(context);

    Future<void> onPressed() async {
      final CheckoutPageController controller = Provider.of<CheckoutPageController>(context, listen: false);

      await controller.confirmButtonOnClicked(context);
    }

    return SizedBox(
      width: 160.0, height: 64.0,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary)),
        child: Text('Pay', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.onPrimary)),
        onPressed: onPressed
      )
    );
  }  
}