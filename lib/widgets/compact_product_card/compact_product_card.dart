import 'dart:math';

import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

class CompactProductCard extends StatefulWidget {
  const CompactProductCard(this.product, { Key? key, this.onTap }) : super(key: key);

  @override
  State<CompactProductCard> createState() => _CompactProductCardState();


  final Product product;
  final void Function()? onTap;
}

class _CompactProductCardState extends State<CompactProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Transform.rotate(
                    angle: -40.0 * (pi / 180.0),
                    child: Image(image: NetworkImage(widget.product.mainImage))
                  )
                ),

                const SizedBox(height: 16.0),

                Text(
                  widget.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2
                ),

                const SizedBox(height: 8.0),

                Text('Rs ${widget.product.initialPrice}')
              ]
            )
          ),
        ),
      )
    );
  }
}