import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(this.order, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      borderRadius: (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius,
      clipBehavior: Clip.hardEdge,
      child: DecoratedBox(        
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[
              theme.cardColor.withOpacity(0.0),
              theme.cardColor
            ]
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildImage(),

              const SizedBox(height: 16.0),

              Text(order.product.name),

              const SizedBox(height: 16.0),

              _buildStepper()
            ],
          ),
        )
      )
    );    
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1,      
      child: Image(image: NetworkImage(order.product.mainImage), fit: BoxFit.cover)
    );
  }

  Widget _buildStepper() {    
    return Stepper(
      type: StepperType.horizontal,
      steps: const <Step>[
        Step(title: Text('Verifying'), content: SizedBox.shrink()),
        
        Step(title: Text('Delivering'), content: SizedBox.shrink()),
        
        Step(title: Text('Delivered'), content: SizedBox.shrink())
      ]      
    );
  }


  final Order order;
}