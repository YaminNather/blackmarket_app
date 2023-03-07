import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../fixed_onboarding_page_slide.dart';

class PurchaseShoesSlide extends StatelessWidget {
  const PurchaseShoesSlide({ required this.index, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FixedOnboardingPageSlide(
      index: index,
      upper: Lottie.asset('assets/loading_indicators/walking_shoes_loading_indicator.json'),
      title: 'The Rarest Shoes Are Waiting To Be Yours',
      description: 'Auction and win some of the rarest shoes and add them to your collection'
    );
  }

  final int index;
}