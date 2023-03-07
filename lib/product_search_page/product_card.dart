import 'dart:math';

import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../product_page/product_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: constraints.maxWidth * leakPercentage),

                SizedBox(
                  width: double.infinity,
                  child: Material(
                    borderRadius: (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius,
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: <Color>[
                            theme.colorScheme.surface.withOpacity(0.4),
                            theme.colorScheme.surface
                          ]
                        )
                      ),
                      child: InkWell(
                        onTap: () {
                          Widget page = ProductPage(id: product.id);
                          MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
                          Navigator.of(context).push(route);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: constraints.maxWidth * (1.0 - leakPercentage)),

                            Align(alignment: Alignment.centerRight, child: _buildTickButton(theme))
                          ],
                        ),
                      )
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                Text(
                  product.name, 
                  style: TextStyle(color: theme.textTheme.bodyText2!.color!.withOpacity(0.5))
                ),

                Text(
                  'Rs ${product.initialPrice}',
                  style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary)
                )
              ]
            ),

            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildImage(constraints.maxWidth)
              )
            )
          ]
        );
      }
    );
  }

  Widget _buildImage(final double maxWidth) {
    final double offsetY = (maxWidth / 2) - (maxWidth * leakPercentage);

    return Transform.translate(
      offset: Offset(0.0, offsetY),
      child: Transform.rotate(
        // origin: const Offset(0.0, 0.5),
        angle: -30.0 * (pi / 180.0),
        // angle: -90.0 * (pi / 180.0),
        child: Image(image: NetworkImage(product.mainImage), fit: BoxFit.cover)
      ),
    );
  }

  Widget _buildTickButton(final ThemeData theme) {
    final RoundedRectangleBorder shape = theme.cardTheme.shape as RoundedRectangleBorder;
    final Radius radius = shape.borderRadius.resolve(TextDirection.ltr).topLeft;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.only(topLeft: radius, bottomRight: radius)
      ),
      padding: const EdgeInsets.all(12.0),
      child: const Icon(Icons.check)
    );
  }

  final Product product;


  static const double leakPercentage = 0.3;
}