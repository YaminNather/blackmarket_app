import 'package:blackmarket_app/onboarding_page/onboarding_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/carousel/carousel_controller.dart';

class CurrentSlideIndicator extends StatefulWidget {
  const CurrentSlideIndicator({ Key? key }) : super(key: key);

  @override
  State<CurrentSlideIndicator> createState() => _CurrentSlideIndicatorState();
}

class _CurrentSlideIndicatorState extends State<CurrentSlideIndicator> {
  @override
  void initState() {
    super.initState();

    _pageController = Provider.of<OnboardingPageController>(context, listen: false);
    _pageController.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final CarouselController carouselController = _pageController.carouselController;

    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        SizedBox.square(
          dimension: 64.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey.shade300,
            strokeWidth: 8.0,
            value: carouselController.pageOffset() / (carouselController.pageCount - 1)
          ),
        ),

        Positioned.fill(
          child: Center(
            child: Text(carouselController.getCurrentPage().toString(), style: theme.textTheme.headline6)
          )
        )
      ]
    );
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    _pageController.removeListener(_update);

    super.dispose();
  }

  
  late final OnboardingPageController _pageController;
}