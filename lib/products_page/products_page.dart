import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:flutter/material.dart';
import '../injector.dart';
import '../widgets/loading_indicator.dart';
import 'product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({ Key? key }) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();    

    _client.inventory().getAllProducts().then(
      (value) => setState( () => _products = value )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody()
      )
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Sneakers"),
      actions: <Widget>[
        IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined))
      ]
    );
  }

  Widget _buildBody() {
    final List<Product>? products = _products;
    if(products == null) {
      return const LoadingIndicator();
    }    

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 16.0,
          crossAxisCount: 2, 
          crossAxisSpacing: 16.0,
          childAspectRatio: 1/1.2
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(product: products[index])
      ),
    );
  }

  
  final Client _client = getIt<Client>();
  List<Product>? _products;
}