import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../../product_page/product_page.dart';

class AddedItemsTabView extends StatefulWidget {
  const AddedItemsTabView(this.soldItems, { Key? key }) : super(key: key);

  @override
  State<AddedItemsTabView> createState() => _AddedItemsTabViewState();


  final List<SoldItem> soldItems;
}

class _AddedItemsTabViewState extends State<AddedItemsTabView> {
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
    return ListTile(
      leading: Image(image: NetworkImage(item.product.mainImage)),
      title:  Text(item.product.name),
      subtitle: Text('Initial Price: ${item.product.initialPrice}'),
      onTap: () {
        MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: item.product.id));
        Navigator.of(context).push(route);
      }
    );
  }  
}