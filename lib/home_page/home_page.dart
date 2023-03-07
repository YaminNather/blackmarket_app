import 'package:blackmarket_app/login_or_authentication_redirector/login_or_authentication_redirector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../add_product_page/add_product_page.dart';
import '../product_page/product_page.dart';
import '../widgets/carousel/carousel.dart';
import '../widgets/carousel/carousel_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import '../current_bids_page/bids_page.dart';
import '../orders_page/orders_page.dart';
import '../widgets/loading_indicator.dart';
import '../your_items_page/your_items_page.dart';
import '../injector.dart';
import '../widgets/carousel/carousel_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/compact_product_card/compact_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future<void> asyncPart() async {
      final List<Future<dynamic>> getTasks = <Future<dynamic>>[
        _inventory.getLatestArrivals(),
        _bidServices.getBidsOfUser()
      ];
      final List<dynamic> tasksResults = await Future.wait(getTasks);
      final List<BidWithProduct> bids = tasksResults[1];
      bids.removeWhere((element) => element.status != BidStatus.pending);

      setState(
        () {
          _latestArrivals = tasksResults[0];
          _bids = bids;
          _isLoading = false;
        }
      );
    }

    asyncPart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), drawer: _buildDrawer(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Home'));
  }

  // Widget _buildSearchButton() {
  //   void onPressed() {
  //     final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const ProductSearchPage());
  //     Navigator.of(context).push(route);
  //   }

  //   return IconButton(icon: const Icon(Icons.search), onPressed: onPressed);
  // }

  Widget _buildBody() {
    if(_isLoading)
      return const LoadingIndicator();

    final List<Product> latestArrivals = _latestArrivals!;    

    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size screenSize = mediaQuery.size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Text('Discover', style: theme.textTheme.headline4),
            // ),

            // const SizedBox(height: 32.0),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Latest Arrivals', style: theme.textTheme.headline6),
            ),
            
            const SizedBox(height: 16.0),

            SizedBox(
              height: screenSize.width - 64.0,
              child: Carousel.builder(
                controller: _latestArrivalsCarouselController,
                itemCount: latestArrivals.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProductCard(latestArrivals[index])
                  );
                }
              )
            ),

            const SizedBox(height: 8.0),

            Center(
              child: CarouselPageIndicator(
                controller: _latestArrivalsCarouselController,
                pagesCount: latestArrivals.length
              ),
            ),

            const SizedBox(height: 32.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Current Bids', style: theme.textTheme.headline6),

                  TextButton(
                    child: const Text('Show all'), 
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(builder: (context) => const BidsPage());
                      Navigator.of(context).push(route);
                    }
                  )
                ]
              )
            ),

            // const SizedBox(height: 16.0),

            _buildCurrentBids(screenSize)
          ]
        )
      )
    );
  }

  Widget _buildCurrentBids(final Size screenSize) {
    final List<BidWithProduct> bids = _bids!;

    if(bids.isEmpty) {
      return Container(height: 64.0, alignment: Alignment.center, child: const Text('Nothing to show here'));
    }

    return SizedBox(
      height: 272.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: bids.length,
        itemBuilder: (context, index) {
          final Product product = bids[index].product;

          return SizedBox(
            width: screenSize.width / 2,
            child: CompactProductCard(
              product,
              onTap: () {
                final Widget page = ProductPage(id: product.id);
                final MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
                Navigator.of(context).push(route);
              }
            )
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 4.0)
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(      
          children: <Widget>[
            ListTile(
              title: const Text('Current Bids'), 
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const BidsPage());
                Navigator.of(context).push(route);
              }
            ),

            ListTile(
              title: const Text('Orders'),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const OrdersPage());
                Navigator.of(context).push(route);
              }
            ),

            ListTile(
              title: const Text('Your Items'),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const YourItemsPage());
                Navigator.of(context).push(route);
              }
            ),
            
            ListTile(
              title: const Text('Add Product'),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => const AddProductPage());
                Navigator.of(context).push(route);
              }
            ),

            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await _authentication.logout();

                final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const LoginOrAuthenticationRedirector());
                Navigator.of(context).pushReplacement(route);
              }
            ),

            ListTile(
              title: const Text('Make as first time'),
              onTap: () async {
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.remove('first_launch');
              }
            )
          ]
        ),
      )
    );
  }



  bool _isLoading = true;
  List<Product>? _latestArrivals;
  List<BidWithProduct>? _bids;

  final Authentication _authentication = getIt<Client>().authentication();
  final Inventory _inventory = getIt<Client>().inventory();
  final BidServices _bidServices = getIt<Client>().bidServices();

  final CarouselController _latestArrivalsCarouselController = CarouselController();
}


// List<Product> frontendSampleProducts = <Product>[
//   Product(
//     id: '0',
//     name: 'Nike Air Vapor Max 2020 FK',
//     seller: 'Yamin',
//     description: 'Crazy shoe',    
//     initialPrice: 3000.0,
//     createdAt: DateTime(2022, 1, 23),
//     mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
//     images: <String>[
//       'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png'
//     ],
//     isAvailable: true
//   ),
//   Product(
//     id: '1',
//     name: 'Puma Insidiator',
//     seller: 'Yamin',
//     description: 'Amazing shoe',    
//     initialPrice: 3000.0,
//     createdAt: DateTime(2022, 1, 21),
//     mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
//     images: <String>[
//       'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png'
//     ],
//     isAvailable: true
//   ),
//   Product(
//     id: '0',
//     name: 'Nike Radion',
//     seller: 'Yamin',
//     description: 'Crazy shoe',    
//     initialPrice: 3000.0,
//     createdAt: DateTime(2022, 1, 23),
//     mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
//     images: <String>[
//       'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png'
//     ],
//     isAvailable: true
//   ),
//   Product(
//     id: '1',
//     name: 'Puma Insidiator',
//     seller: 'Yamin',
//     description: 'Amazing shoe',    
//     initialPrice: 3000.0,
//     createdAt: DateTime(2022, 1, 21),
//     mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
//     images: <String>[
//       'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png'
//     ],
//     isAvailable: true
//   ),
//   Product(
//     id: '0',
//     name: 'Nike Radion',
//     seller: 'Yamin',
//     description: 'Crazy shoe',    
//     initialPrice: 3000.0,
//     createdAt: DateTime(2022, 1, 23),
//     mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
//     images: <String>[
//       'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png'
//     ],
//     isAvailable: true
//   ),
//   Product(
//     id: '1',
//     name: 'Puma Insidiator',
//     seller: 'Yamin',
//     description: 'Amazing shoe',    
//     initialPrice: 3000.0,
//     createdAt: DateTime(2022, 1, 21),
//     mainImage: 'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png',
//     images: <String>[
//       'https://nzjzbovrzkimbccsxptb.supabase.co/storage/v1/object/public/default-bucket/shoe.png'
//     ],
//     isAvailable: true
//   )
// ];