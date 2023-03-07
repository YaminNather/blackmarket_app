import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../fixed_onboarding_page_slide.dart';

class FromTheComfortOfYourHomeSlide extends StatelessWidget {
  const FromTheComfortOfYourHomeSlide({ required this.index, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FixedOnboardingPageSlide(
      index: index,
      upper: Lottie.asset('assets/onboarding_page_animations/using_a_laptop.json'),
      title: 'All From The Comfort Of Your Home',
      description: 'Do all this from anywhere you like and have your product delivered right to you'
    );
  }

  final int index;
}