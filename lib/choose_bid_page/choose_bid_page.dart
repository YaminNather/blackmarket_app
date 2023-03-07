import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'final_acceptance_dialog.dart';
import '../widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../injector.dart';
import '../product_page/images_carousel/images_carousel.dart';

class ChooseBidPage extends StatefulWidget {
  const ChooseBidPage(this.product, { Key? key }) : super(key: key);

  @override
  State<ChooseBidPage> createState() => _ChooseBidPageState();


  final String product;
}

class _ChooseBidPageState extends State<ChooseBidPage> {
  @override
  void initState() {
    super.initState();

    Future<void>(
      () async {
        final Product? product = (await _inventory.getProduct(widget.product))!;
        final List<Bid>? bid = (await _bidServices.getBidsForProduct(widget.product));
        setState(
          () {
            _product = product;
            _bids = bid;
            _isLoading = false;
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Choose Bid'));
  }

  Widget _buildBody() {
    if(_isLoading)
      return const LoadingIndicator();

    final ThemeData theme = Theme.of(context);

    final Product product = _product!;
    final List<Bid> bids = _bids!;    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ImagesCarousel(product: product),

        const SizedBox(height: 32.0),

        SizedBox(
          height: 40.0,
          child: Marquee(
            text: product.name.toUpperCase(),
            style: theme.textTheme.headline5,
            pauseAfterRound: const Duration(milliseconds: 5000)
          )
        ),

        const SizedBox(height: 32.0),

        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text('Bids', style: theme.textTheme.headline6),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: bids.length,
            itemBuilder: (context, index) => _buildListTile(bids[index])
          )
        )
      ]
    );
  }

  Widget _buildListTile(final Bid bid) {
    return ListTile(
      title: Text('Rs.${bid.amount}'),
      subtitle: Text(bid.bidder.username),
      onTap: () async {
        bool? accepted = await showDialog(context: context, builder: (context) => FinalAcceptanceDialog(bid));
        if(accepted == null)
          return;

        if(!accepted) {
          ScaffoldMessenger.of(context).showSnackBar(_buildNotAcceptedMessageSnackBar(bid));
          return; 
        }
      
        await _bidServices.acceptBid(bid.bidder.id, bid.productId);

        ScaffoldMessenger.of(context).showSnackBar(_buildAcceptedMessageSnackBar(bid));
        Navigator.of(context).pop();
      }
    );
  }

  SnackBar _buildNotAcceptedMessageSnackBar(final Bid bid) {
    final ThemeData theme = Theme.of(context);

    return SnackBar(
      content: RichText(
        text: TextSpan(
          text: 'Bid of Rs ',
          style: theme.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(text: ' ${bid.amount}'),

            const TextSpan(text: ' by'),

            TextSpan(text: ' ${bid.bidder.username}'),

            const TextSpan(text: ' has not been accepted')
          ]
        )
      )
    );
  }

  SnackBar _buildAcceptedMessageSnackBar(final Bid bid) {
    final ThemeData theme = Theme.of(context);

    return SnackBar(
      content: RichText(
        text: TextSpan(
          text: 'Bid of Rs ',
          style: theme.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(text: ' ${bid.amount}'),

            const TextSpan(text: ' by'),

            TextSpan(text: ' ${bid.bidder.username}'),

            const TextSpan(text: ' has been accepted')
          ]
        )
      )
    );
  }


  bool _isLoading = true;
  Product? _product;
  List<Bid>? _bids;


  final Inventory _inventory = getIt<Client>().inventory();
  final BidServices _bidServices = getIt<Client>().bidServices();
}