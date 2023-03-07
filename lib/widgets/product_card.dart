import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../product_page/product_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: product.id));
          Navigator.of(context).push(route);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Center(child: _buildImage())
              ),

              const SizedBox(height: 48.0),

              Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),

              const SizedBox(height: 8.0),
              
              Text('Rs. ${product.initialPrice}')
            ]
          )
        )
      )
    );    
  }

  Widget _buildImage() {
    return Image(image: NetworkImage(product.mainImage), fit: BoxFit.contain);
  }


  final Product product;
}