import 'package:blackmarket_app/checkout_page/checkout_page.dart';
import 'package:blackmarket_app/product_page/sell_dialog.dart';

import '../widgets/loading_indicator.dart';
import 'bid_dialog.dart';

import 'images_carousel/images_carousel.dart';
import 'package:flutter/material.dart';
import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:marquee/marquee.dart';

import '../injector.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({ Key? key, required this.id }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();


  final String id;
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();    

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar: _buildAppBar(), body: _buildBody()));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar();
  }

  Widget _buildBody() {
    final ThemeData theme = Theme.of(context);

    if(_isLoading)
      return const LoadingIndicator();
    
    final Product product = _product!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ImagesCarousel(product: product),

                const SizedBox(height: 32.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildProductName(theme),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildPriceDetails(theme),

                          _buildSizeInfo()
                        ]
                      ),

                      _buildSoldByDetails(theme),

                      const SizedBox(height: 16.0),                      

                      _buildDescription()
                    ]
                  ),
                ),

                const SizedBox(height: 16.0)
              ]
            )
          )
        ),

        const SizedBox(height: 16.0),

        _buildBottomArea()
      ]
    );
  }

  Widget _buildProductName(final ThemeData theme) {
    final Product product = _product!;

    return SizedBox(
      height: 40.0,
      child: Marquee(        
        text: product.name.toUpperCase(),
        startPadding: 128.0,
        style: theme.textTheme.headline5,
        pauseAfterRound: const Duration(milliseconds: 5000)
      )
    );
  }

  Widget _buildSizeInfo() {
    final ThemeData theme = Theme.of(context);

    final Product product = _product!;

    return RichText(
      text: TextSpan(
        text: 'Size: ',
        style: theme.textTheme.bodyText2,
        children: <TextSpan>[
          TextSpan(text: '10', style: theme.textTheme.headline6)
        ]
      )
    );
  }

  Widget _buildPriceDetails(ThemeData theme) {
    final Product product = _product!;

    return Text('Rs ${product.initialPrice}', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary));
  }

  Widget _buildSoldByDetails(final ThemeData theme) {
    final Product product = _product!;

    return RichText(
      text: TextSpan(
        text: 'Sold by:',
        style: theme.textTheme.bodyText2,
        children: <TextSpan>[
          TextSpan(text: ' ${product.seller.username}', style: theme.textTheme.headline6)
        ]
      )
    );
  }

  Widget _buildDescription() {
    final Product product = _product!;
    
    return Text(product.description);
  }

  Widget _buildBottomArea() {
    final ThemeData theme = Theme.of(context);

    final Product product = _product!;

    if(product.seller.id == _currentUser)
      return const SizedBox.shrink();

    final Widget content;
    if(product.isAvailable)
      content = _buildPendingProductActions(theme);
    else
      content = _buildAcceptedProductActions();
    
    return Container(
      width: double.infinity,
      decoration: new BoxDecoration(
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16.0)
      ),
      padding: const EdgeInsets.all(16.0),
      child: content
    );
  }

  Widget _buildPendingProductActions(final ThemeData theme) {
    final Bid? bidByUser = _bidByUser;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if(bidByUser != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: 'Current Bid: ',
                  style: theme.textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(text: ' Rs ${bidByUser.amount}', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.primary))
                  ]
                )
              ),

              const SizedBox(height: 16.0)
            ]
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBidButton(),
            
            _buildSellButton()
          ]
        ),
      ],
    );
  }

  Widget _buildAcceptedProductActions() {
    return const Center(child: Text('Bidding not available at the moment for this product'));

    // final ThemeData theme = Theme.of(context);
    
    // final Product product = _product!;

    // Future<void> onPressed() async {
    //   final MaterialPageRoute route = MaterialPageRoute(builder: (context) => CheckoutPage(product: product));
    //   Navigator.of(context).pushReplacement(route);
    // }

    // return SizedBox(
    //   width: 160.0, height: 64.0,
    //   child: ElevatedButton(
    //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary)),
    //     child: Text('Checkout', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.onPrimary)),
    //     onPressed: onPressed
    //   )
    // );
  }

  Widget _buildBidButton() {
    final ThemeData theme = Theme.of(context);

    final Product product = _product!;

    Future<void> onPressed() async {
      final bool? bidDone = await showDialog(context: context, builder: (context) => BidDialog(product));      
      if(bidDone == null || bidDone == false)
        return;
      
      await _loadData();

      // await _bidServices().placeBid(product.id, double.parse(_amountFieldController.text));
      // await _getBidsFromBackend();
    }

    return SizedBox(
      width: 160.0, height: 64.0,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(theme.colorScheme.primary)),
        child: Text('Bid', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.onPrimary)),
        onPressed: onPressed
      )
    );
  }

  Widget _buildSellButton() {
    final ThemeData theme = Theme.of(context);
    Future<void> onPressed() async {
      final Product? soldProduct = await showDialog(context: context, builder: (context) => SellDialog(_product!));
      if(soldProduct == null)
        return;

      final MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: soldProduct.id));
      await Navigator.of(context).pushReplacement(route);
      // setState(() => _isLoading = true);
      // final Product createdProduct = await _inventory().sellBid(_product!.id, _getAmountFieldValue());

      // MaterialPageRoute route = MaterialPageRoute(builder: (context) => ProductPage(id: createdProduct.id));
      // Navigator.of(context).pushReplacement(route);
      // setState(() => _isLoading = false);
    }

    return SizedBox(
      width: 160.0, height: 64.0,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        child: Text('Sell', style: theme.textTheme.headline6!.copyWith(color: theme.colorScheme.onPrimary)),
        onPressed: onPressed
      )
    );
  }

  Future<void> _getBidsFromBackend() async {
    List<Bid> bids = await _bidServices().getBidsForProduct(_product!.id);
    setState(() => _bids = bids);
  }  

  Future<void> _loadData() async {
      setState(() => _isLoading = true);

      final Product product = (await _client.inventory().getProduct(widget.id))!;
      final List<Bid> bids = await _bidServices().getBidsForProduct(product.id);
      final String currentUser = (await _authentication.getCurrentUser())!;

      setState(
        () {
          _product = product;
          _bids = bids;
          int bidByUserIndex = bids.indexWhere((bid) => bid.bidder.id == currentUser);
          _bidByUser = (bidByUserIndex != -1) ? bids[bidByUserIndex] : null;
          _currentUser = currentUser;
          _isLoading = false;          
        }
      );
    }

  BidServices _bidServices() => _client.bidServices();


  bool _isLoading = true;

  Product? _product;
  List<Bid>? _bids;
  Bid? _bidByUser;
  String? _currentUser;
  
  final Client _client = getIt<Client>();
  final Authentication _authentication = getIt<Client>().authentication();  
}