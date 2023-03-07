import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/checkout_page/checkout_page.dart';
import 'package:flutter/material.dart';

class OrderProgressStepper extends StatefulWidget {
  const OrderProgressStepper(this.order, { Key? key }) : super(key: key);

  @override
  State<OrderProgressStepper> createState() => _OrderProgressStepperState();

  final Order order;
}

class _OrderProgressStepperState extends State<OrderProgressStepper> {
  @override
  void initState() {    
    super.initState();

    _currentlyExpandedStep = widget.order.status.index;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stepper(
      currentStep: _currentlyExpandedStep,
      onStepTapped: (index) => setState(() => _currentlyExpandedStep = index),
      steps: <Step>[
        _buildStep(index: 0, title: const Text('Verifying')),
        
        _buildStep(
          index: 1, 
          title: const Text('Verified'), 
          content: ElevatedButton(
            child: const Text('Checkout'), 
            onPressed: () async {
              final MaterialPageRoute route = MaterialPageRoute(builder: (context) => CheckoutPage(product: widget.order.product));
              await Navigator.of(context).push(route);
            }
          )
        ),

        _buildStep(
          index: 2,
          title: const Text('Delivering'),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Delivery Address', style: theme.textTheme.headline6),

                const SizedBox(height: 8.0),

                Text(widget.order.deliverTo)
              ]
            )
          )
        ),

        _buildStep(index: 3, title: const Text('Delivered'))
      ],
      controlsBuilder: (context, details) => const SizedBox(width: double.infinity)
    );
  }

  Step _buildStep({required int index, required Widget title, Widget? content}) {
    return Step(
      isActive: index <= widget.order.status.index, 
      title: title, 
      content: content ?? const SizedBox(width: double.infinity),
      state: (index < widget.order.status.index) ? StepState.complete : StepState.indexed
    );
  }



  int _currentlyExpandedStep = 0;
}