import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../fixed_onboarding_page_slide.dart';

class SellProductsSlide extends StatefulWidget {
  const SellProductsSlide({ required this.index, Key? key }) : super(key: key);

  @override
  State<SellProductsSlide> createState() => _SellProductsSlideState();


  final int index;
}

class _SellProductsSlideState extends State<SellProductsSlide> {
  @override
  Widget build(BuildContext context) {
    return FixedOnboardingPageSlide(
      index: widget.index,
      upper: Lottie.asset('assets/onboarding_page_animations/sell_products_animation.json'),
      title: 'Auction Off Your Shoes',
      description: 'Have any exotic shoes with you? \nAuction them off and make crazy money'
    );
  }
}