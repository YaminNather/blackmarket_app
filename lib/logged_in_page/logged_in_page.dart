import 'package:flutter/material.dart';

import '../home_page/home_page.dart';
import '../product_search_page/product_search_page.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({ Key? key }) : super(key: key);

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(), bottomNavigationBar: _buildBottomNavigationBar());
  }

  Widget _buildBody() {
    if(_pageIndex == 0)
      return const HomePage();
    else
      return const ProductSearchPage();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        
        BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search')
      ],
      currentIndex: _pageIndex,
      onTap: (index) => setState(() => _pageIndex = index)
    );
  }


  int _pageIndex = 0;
}