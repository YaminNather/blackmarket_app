import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../fixed_onboarding_page_slide.dart';

class DeliverySlide extends StatelessWidget {
  const DeliverySlide({ required this.index, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FixedOnboardingPageSlide(
      index: index,
      upper: Lottie.asset('assets/onboarding_page_animations/delivering_animation.json'),
      title: 'Delivery To Your Doorstep',
      description: 'Get the shoes you auctioned for right to your doorstep in less than 3 days'
    );
  }

  final int index;
}