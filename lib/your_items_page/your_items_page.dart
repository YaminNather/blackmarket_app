import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/your_items_page/bidding_items_tab_view.dart';
import 'package:blackmarket_app/your_items_page/your_items_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_indicator.dart';
import 'accepted_items_tab_view.dart';
import 'added_items_tab_view.dart';

class YourItemsPage extends StatefulWidget {
  const YourItemsPage({ Key? key }) : super(key: key);

  @override
  State<YourItemsPage> createState() => _YourItemsPageState();
}

class _YourItemsPageState extends State<YourItemsPage> {
  @override
  void initState() {
    super.initState();

    _controller = YourItemsPageController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider<YourItemsPageController>(
        create: (context) => _controller..loadData(),
        child: Scaffold(appBar: _buildAppBar(), body: _buildBody())
      )
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Your Items'));
  }

  Widget _buildBody() {
    final ThemeData theme = Theme.of(context);

    return Consumer<YourItemsPageController>(
      builder: (context, value, child) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              TabBar(
                labelColor: theme.textTheme.bodyText1!.color,
                tabs: const <Tab>[
                  Tab(text: 'Added'),
                  
                  Tab(text: 'Bidding'),
                  
                  Tab(text: 'Accepted')
                ]
              ),

              Expanded(
                child: _buildTabBarView()
              )
            ]
          )
        );
      }      
    );
  }

  Widget _buildTabBarView() {
    if(_controller.isLoading)
      return const LoadingIndicator();

    return TabBarView(
      children: <Widget>[              
        _buildAddedItemsTabView(),

        _buildBiddingItemsTabView(),

        _buildAcceptedItemsTabView()
      ]
    );
  }

  Widget _buildAddedItemsTabView() {
    List<SoldItem> addedItems = List<SoldItem>.from(_controller.soldItems!);
    addedItems.removeWhere((element) => element.bid != null || element.order != null);
    
    return AddedItemsTabView(addedItems);
  }
  
  Widget _buildBiddingItemsTabView() {
    List<SoldItem> biddingItems = List<SoldItem>.from(_controller.soldItems!);
    biddingItems.removeWhere((element) => !(element.bid != null && element.order == null));
    
    return BiddingItemsTabView(biddingItems);
  }
  
  Widget _buildAcceptedItemsTabView() {
    List<SoldItem> acceptedItems = List<SoldItem>.from(_controller.soldItems!);
    acceptedItems.removeWhere((element) => !(element.bid == null && element.order != null));
    
    return AcceptedItemsTabView(acceptedItems);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }



  late final YourItemsPageController _controller;
}