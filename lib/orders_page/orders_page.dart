import 'package:blackmarket_app/checkout_page/checkout_page.dart';
import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:flutter/material.dart';

import '../order_page/order_page.dart';
import '../widgets/loading_indicator.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({ Key? key }) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();

    _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Orders'));
  }

  Widget _buildBody() {
    if(_isLoading)
      return const LoadingIndicator();

    final List<Order> orders = _orders!;

    if(orders.isEmpty)
      return const Center(child: Text('No orders yet'));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final Order order = orders[index];
          
          if(order.status == OrderStatus.verifying)
            return _buildVerifyingItem(order);
          if(order.status == OrderStatus.verified)
            return _buildVerifiedItem(order);
          else if(order.status == OrderStatus.checkedOut)
            return _buildDeliveringItem(order);
          else if(order.status == OrderStatus.delivered)
            return _buildDeliveredItem(order);
          else
            throw Exception();
        },
        separatorBuilder: (context, index) => const Divider(thickness: 2.0)
      )
    );
  }    

  Widget _buildVerifyingItem(final Order order) {
    return _buildItem(order, status: const Text('Item being verified'));
  }  

  Widget _buildVerifiedItem(final Order order) {
    return _buildItem(
      order,
      status: const Text('Verified, click here to checkout')      
    );
  }

  // void _showPaymentSuccessMessage() {
  //   final SnackBar snackBar = SnackBar(
  //     content: Row(
  //       children: const <Widget>[
  //         Icon(Icons.check, color: Colors.green),

  //         SizedBox(width: 16.0),

  //         Text('Payment Success!')
  //       ]
  //     )
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  // void _showPaymentFailedMessage() {
  //   final ThemeData theme = Theme.of(context);

  //   final SnackBar snackBar = SnackBar(
  //     content: Row(
  //       children: <Widget>[
  //         Icon(Icons.error_outline, color: theme.colorScheme.error),

  //         const SizedBox(width: 16.0),

  //         Text('Payment Failed!', style: TextStyle(color: theme.colorScheme.error))
  //       ]
  //     )
  //   );
    
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  Widget _buildDeliveringItem(final Order order) {
    return _buildItem(
      order,
      status: const Text('Item being delivered')
    );
  }

  Widget _buildDeliveredItem(final Order order) {
    return _buildItem(
      order,
      status: const Text('Item delivered')
    );
  }

  Widget _buildItem(final Order order, {required final Widget status, final Widget? trailing}) {
    return ListTile(
      leading: Image(image: NetworkImage(order.product.mainImage)),
      title:  Text(order.product.name),
      subtitle: status,
      trailing: trailing,
      onTap: () {
        MaterialPageRoute route = MaterialPageRoute(builder: (context) => OrderPage(order.product.id));
        Navigator.of(context).push(route);
      }
    );
  }
  
  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final List<Order> orders = await _orderServices.getOrders();
    
    setState(
      () {
        _orders = orders;
        _isLoading = false;
      }
    );
  }


  bool _isLoading = true;
  List<Order>? _orders;

  final OrderServices _orderServices = getIt<Client>().orderServices();
}