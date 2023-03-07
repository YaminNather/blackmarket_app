import 'package:blackmarket_app/onboarding_page/onboarding_page_controller.dart';
import 'package:blackmarket_app/onboarding_page/onboarding_page_slide_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/carousel/carousel_controller.dart';

class OnboardingPageScrollSpeedAdjuster extends StatefulWidget {
  const OnboardingPageScrollSpeedAdjuster({this.speedMultiplier = 1.0, required this.child, Key? key }) : super(key: key);

  @override
  State<OnboardingPageScrollSpeedAdjuster> createState() => _OnboardingPageScrollSpeedAdjusterState();
  
  final double speedMultiplier;
  final Widget child;
}

class _OnboardingPageScrollSpeedAdjusterState extends State<OnboardingPageScrollSpeedAdjuster> {
  @override
  Widget build(BuildContext context) {
    final double offsetFromOnScreenScrollOffset = _getOffsetFromOnScreenScrollOffset();

    return Transform.translate(
      offset: Offset(-offsetFromOnScreenScrollOffset + (offsetFromOnScreenScrollOffset * widget.speedMultiplier), 0.0), 
      child: widget.child
    );
  }

  double _getOffsetFromOnScreenScrollOffset() {
    final OnboardingPageController pageController = Provider.of<OnboardingPageController>(context, listen: false);
    final CarouselController carouselController = pageController.carouselController;

    final OnboardingPageSlideData slideController = Provider.of<OnboardingPageSlideData>(context, listen: false);
    
    final double onScreenScrollOffset = carouselController.getScrollOffsetOfPage(slideController.index);
    final double scrollOffset = carouselController.scrollOffset();

    final double r = onScreenScrollOffset - scrollOffset;
    return r;
  }

  // double _getOffset
}