
   import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/product_page/product_page.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({ Key? key, required this.product }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();


  final Product product;
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              final MaterialPageRoute route = new MaterialPageRoute(
                builder: (context) => ProductPage(id: widget.product.id)
              );
              Navigator.of(context).push(route);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 32.0),

                  SizedBox(
                    width: double.infinity, height: 80.0,
                    child: Image.network(widget.product.mainImage)
                  ),

                  const SizedBox(height: 16.0),

                  Text(widget.product.name, style: const TextStyle(overflow: TextOverflow.ellipsis)),
                  
                  const SizedBox(height: 8.0),

                  Text(
                    'Lowest Ask', 
                    style: theme.textTheme.subtitle2!.copyWith(
                      color: theme.textTheme.bodyText2!.color!.withOpacity(0.7)
                    )
                  ),

                  const SizedBox(height: 8.0),

                  Text('Rs. ${widget.product.initialPrice}', style: theme.textTheme.headline6)
                ]
              )
            ),
          ),

          Positioned(
            right: 4.0,
            child: IconButton(
              icon: const Icon(Icons.favorite_outline_outlined), onPressed: () {}
            )
          )
        ]
      )
    );
  }
}