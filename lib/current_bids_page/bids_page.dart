import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:blackmarket_app/product_page/product_page.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_indicator.dart';

class BidsPage extends StatefulWidget {
  const BidsPage({ Key? key }) : super(key: key);

  @override
  State<BidsPage> createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  @override
  void initState() {
    super.initState();

    Future<void> asyncPart() async {
      final List<BidWithProduct> bids = await _bidServices.getBidsOfUser();
      
      setState(
        () {
          _bids = bids;
          _isLoading = false;
        }
      );
    }

    asyncPart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Bids'));
  }

  Widget _buildBody() {
    if(_isLoading)
      return const LoadingIndicator();

    final List<BidWithProduct> bids = _bids!;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: bids.length,
        itemBuilder: (context, index) {
          final BidWithProduct bid = bids[index];
          
          if(bid.status == BidStatus.pending)
            return _buildOngoingBidItem(bid);
          else if(bid.status == BidStatus.declined)
            return _buildDeclinedBidItem(bid);
          else
          return _buildAcceptedBidItem(bid);
        },
        separatorBuilder: (context, index) => const Divider(thickness: 2.0)
      )
    );
  }

  Widget _buildItem(final BidWithProduct bid, {required final Widget bidStatus}) {
    return ListTile(
      leading: Image(image: NetworkImage(bid.product.mainImage)),
      title:  Text(bid.product.name),
      subtitle: bidStatus,
      onTap: () {
        MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: bid.product.id));
        Navigator.of(context).push(route);
      }
    );
  }

  Widget _buildOngoingBidItem(final BidWithProduct bid) {
    final ThemeData theme = Theme.of(context);

    return _buildItem(
      bid,
      bidStatus: RichText(
        text: TextSpan(
          text: 'Current Bid: ',
          style: theme.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(text: 'Rs ${bid.amount}', style: theme.textTheme.headline6!.copyWith(color: Colors.green))
          ]
        )
      )
    );
  }

  Widget _buildDeclinedBidItem(final BidWithProduct bid) {
    final ThemeData theme = Theme.of(context);

    return _buildItem(bid, bidStatus: Text('Bid declined', style: TextStyle(color: theme.colorScheme.error)) );
  }

  Widget _buildAcceptedBidItem(final BidWithProduct bid) {
    return _buildItem(
      bid,
      bidStatus: const Text('Bid Accepted', style: TextStyle(color: Colors.green))
    );
  }



  bool _isLoading = true;
  List<BidWithProduct>? _bids;

  final BidServices _bidServices = getIt<Client>().bidServices();
}