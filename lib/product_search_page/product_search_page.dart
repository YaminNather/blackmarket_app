import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:flutter/material.dart';

import '../product_page/product_page.dart';
import '../widgets/compact_product_card/compact_product_card.dart';
import '../widgets/loading_indicator.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({ Key? key }) : super(key: key);

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  @override
  void initState() {    
    super.initState();

    Future<void> asyncPart() async {
      setState(() => _isLoading = true);

      final List<Product> allProducts = await _inventory.getAllProducts();
      _allProducts = allProducts;
      _searchSuggestions = _allProducts;
      
      setState(() => _isLoading = false);
    }

    asyncPart();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar: _buildAppBar(), body: _buildBody()));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Search'));
  }

  Widget _buildBody() {
    if(_isLoading)
      return const LoadingIndicator();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSearchField()
          ),

          Expanded(
            child: _buildSearchResults()
          )
        ]
      )
    );
  }

  Widget _buildSearchResults() {
    final List<Product> searchSuggestions = _searchSuggestions!;
    
    const double padding = 16.0;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, 
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0/1.5
      ),
      padding: const EdgeInsets.all(padding),
      itemCount: searchSuggestions.length,
      itemBuilder: (context, index) {
        final Product product = searchSuggestions[index];
        return CompactProductCard(
          searchSuggestions[index],
          onTap: () async {
            MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: product.id));
            await Navigator.of(context).push(route);
          }
        );
      }      
    );
  }

  Widget _buildSearchField() {
    return TextField(    
      controller: _searchFieldController,
      decoration: const InputDecoration(
        hintText: 'Search', 
        suffixIcon: Icon(Icons.search),
        border: OutlineInputBorder()
      ),
      onChanged: (text) => _updateSearch(text)
    );
  }

  Future<void> _updateSearch(final String searchTerm) async {
    final List<Product> allProducts = _allProducts!;
    final List<Product> searchSuggestions = <Product>[];
    for(final Product product in allProducts) {
      if(product.name.toLowerCase().contains(searchTerm.toLowerCase()))
        searchSuggestions.add(product);
    }

    setState(() => _searchSuggestions = searchSuggestions);
  }  



  bool _isLoading = true;
  List<Product>? _allProducts;
  List<Product>? _searchSuggestions;

  final TextEditingController _searchFieldController = TextEditingController();

  final Inventory _inventory = getIt<Client>().inventory();  

  // static Product product = Product(
  //   id: '0',
  //   name: 'Nike Radion',
  //   seller: 'Yamin',
  //   description: 'Crazy shoe',    
  //   initialPrice: 3000.0,
  //   createdAt: DateTime(2022, 1, 23),
  //   mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
  //   images: <String>[
  //     'https://freepngimg.com/thumb/categories/627.png'
  //   ],
  //   isAvailable: true
  // );
}