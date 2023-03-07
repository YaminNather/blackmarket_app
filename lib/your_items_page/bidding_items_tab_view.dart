import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/choose_bid_page/choose_bid_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'your_items_page_controller.dart';

class BiddingItemsTabView extends StatefulWidget {
  const BiddingItemsTabView(this.soldItems, { Key? key }) : super(key: key);

  @override
  State<BiddingItemsTabView> createState() => _BiddingItemsTabViewState();


  final List<SoldItem> soldItems;
}

class _BiddingItemsTabViewState extends State<BiddingItemsTabView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.soldItems.length,
      itemBuilder: (context, index) => _buildItem(widget.soldItems[index]),
      separatorBuilder: (context, index) => const Divider(thickness: 2.0)
    );
  }

  Widget _buildItem(final SoldItem item) {
    final YourItemsPageController controller = Provider.of<YourItemsPageController>(context);

    return ListTile(
      leading: Image(image: NetworkImage(item.product.mainImage)),
      title:  Text(item.product.name),
      subtitle: Text('Highest Bid: ${item.bid!.amount}'),
      onTap: () async {
        MaterialPageRoute route = MaterialPageRoute(builder: (context) => ChooseBidPage(item.product.id));
        await Navigator.of(context).push(route);

        await controller.loadData();
      }
    );
  }
}