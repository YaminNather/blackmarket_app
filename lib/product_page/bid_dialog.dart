import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../injector.dart';

class BidDialog extends StatefulWidget {
  const BidDialog(this.product, { Key? key }) : super(key: key);

  @override
  State<BidDialog> createState() => _BidDialogState();


  final Product product;
}

class _BidDialogState extends State<BidDialog> {
  @override
  void initState() {
    super.initState();

    _amountFieldController.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Place Bid'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(controller: _amountFieldController, decoration: const InputDecoration(hintText: 'Amount')),

          const SizedBox(height: 16.0),

          if(error != null)
            Text(error!, style: TextStyle(color: theme.colorScheme.error))
        ]
      ),
      actions: <Widget>[
        _buildCancelButton(),

        _buildMakeBidButton()
      ]
    );
  }

  Widget _buildCancelButton() {
    return OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop());
  }

  Widget _buildMakeBidButton() {
    Future<void> onPressed() async {
      final double? amount = double.tryParse(_amountFieldController.text);
      if(amount == null) {
        setState(() => error = 'Enter a valid amount');
        return;
      }

      if(amount <= 0.0) {
        setState(() => error = 'Enter an amount greater than 0');
        return;
      }

      if(amount <= widget.product.initialPrice) {
        setState(() => error = 'Enter a amount greater than lowest price');
        return;
      }

      await _bidServices.placeBid(widget.product.id, amount);

      ScaffoldMessenger.of(context).showSnackBar(_buildBidPlacedNotifierSnackBar(amount));

      Navigator.of(context).pop<bool>(true);
    }

    return ElevatedButton(
      child: const Text('Place Bid'), 
      onPressed: (_amountFieldController.text.isNotEmpty) ?  onPressed : null
    );
  }

  SnackBar _buildBidPlacedNotifierSnackBar(final double amount) {
    final ThemeData theme = Theme.of(context);

    return SnackBar(
      content: RichText(
        text: TextSpan(
          text: 'Placed bid of Rs.',
          style: theme.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(text: ' $amount', style: const TextStyle(fontWeight: FontWeight.bold))
          ]
        )
      )
    );
  }

  @override
  void dispose() {
    _amountFieldController.removeListener(_update);
    _amountFieldController.dispose();
    
    super.dispose();
  }

  void _update() => setState(() {});


  final TextEditingController _amountFieldController = TextEditingController(text: '0.0');
  String? error;  

  final BidServices _bidServices = getIt<Client>().bidServices();
}