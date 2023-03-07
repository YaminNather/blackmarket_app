import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';

import '../../product_page/product_page.dart';

class AcceptedItemsTabView extends StatefulWidget {
  const AcceptedItemsTabView(this.soldItems, { Key? key }) : super(key: key);

  @override
  State<AcceptedItemsTabView> createState() => _AcceptedItemsTabViewState();


  final List<SoldItem> soldItems;
}

class _AcceptedItemsTabViewState extends State<AcceptedItemsTabView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.soldItems.length,
      itemBuilder: (context, index) {
        final SoldItem item = widget.soldItems[index];
        
        if(item.order!.status == OrderStatus.verifying)
          return _buildVerifyingItem(item);
        else if(item.order!.status == OrderStatus.checkedOut)
          return _buildDeliveringItem(item);
        else
          return _buildDeliveredItem(item);
      },
      separatorBuilder: (context, index) => const Divider(thickness: 2.0)
    );
  }

  Widget _buildItem(SoldItem item, {required final Widget status}) {
    return ListTile(
      leading: Image(image: NetworkImage(item.product.mainImage)),
      title:  Text(item.product.name),
      subtitle: status,
      onTap: () {
        MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: item.product.id));
        Navigator.of(context).push(route);
      }
    );
  }

  Widget _buildVerifyingItem(SoldItem item) {
    return _buildItem(item, status: const Text('Verifying'));
  }
  
  Widget _buildDeliveringItem(SoldItem item) {
    return _buildItem(item, status: const Text('Delivering'));
  }
  
  Widget _buildDeliveredItem(SoldItem item) {
    return _buildItem(item, status: const Text('Delivered'));
  }
}