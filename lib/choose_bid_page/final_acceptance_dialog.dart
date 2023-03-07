import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

class FinalAcceptanceDialog extends StatelessWidget {
  const FinalAcceptanceDialog(this.bid, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Accept Bid'),
      content: RichText(
        text: TextSpan(
          text: 'Are you sure you want to accept this bid of',
          style: theme.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(text: ' Rs ${bid.amount}', style: const TextStyle(fontWeight: FontWeight.bold)),

            const TextSpan(text: ' by'),

            TextSpan(text: ' ${bid.bidder.username}', style: const TextStyle(fontWeight: FontWeight.bold)),

            const TextSpan(text: '?')
          ]
        )
      ),
      actions: <Widget>[
        TextButton(child: const Text('No'), onPressed: () => Navigator.of(context).pop<bool>(false)),

        ElevatedButton(child: const Text('Accept'), onPressed: () => Navigator.of(context).pop<bool>(true))
      ]
    );
  }


  final Bid bid;
}