import 'package:flutter/material.dart';

class PageViewTesting extends StatefulWidget {
  const PageViewTesting({ Key? key }) : super(key: key);

  @override
  State<PageViewTesting> createState() => _PageViewTestingState();
}

class _PageViewTestingState extends State<PageViewTesting> {
  @override
  void initState() {    
    super.initState();

    _pageViewController.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageViewController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ColoredBox(color: Colors.red),
          );
        }
      )
    );
  }

  void _update() => print('PageView scroll amount = ${_pageViewController.page}');

  @override
  void dispose() {
    _pageViewController.removeListener(_update);

    super.dispose();
  }


  final PageController _pageViewController = PageController();
}