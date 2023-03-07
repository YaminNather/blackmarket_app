import 'dart:ui';

import 'package:flutter/material.dart';

class CarouselController extends ChangeNotifier {
  CarouselController() {
    pageController.addListener(notifyListeners);
  }

  void updateWidgetData(final int pageCount) {
    this.pageCount = pageCount;
  }

  int getCurrentPage() {
    try {
      return pageController.page!.floor();
    }
    catch(e) {
      return 0;
    }
  }

  double pageOffset() {
    try {
      return pageController.page!;
    }
    catch(e) {
      return 0;
    }
  }

  double getScrollOffsetOfPage(final int page) {
    if(pageCount == 0)
      return 0;
      
    final double pageOffsetFactor = page / (pageCount - 1);

    return maxScrollOffset() * pageOffsetFactor;
  }

  double scrollOffset() {
    try {
      return pageController.offset;
    }
    catch(e) {
      return 0;
    }
  }

  double maxScrollOffset() {
    try {
      return pageController.position.maxScrollExtent;
    }
    catch(e) {
      return 0;
    }
  }

  Future<void> animateToPage(
    final int index, 
    {
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.easeInOut
    }
  ) async {
    await pageController.animateToPage(index, duration: duration, curve: curve);
  }

  @override
  void dispose() {
    pageController.removeListener(notifyListeners);

    super.dispose();
  }


  int pageCount = 0;
  final PageController pageController = PageController();
}