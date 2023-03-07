import 'package:flutter/material.dart';

import '../widgets/carousel/carousel_controller.dart';

class OnboardingPageController extends ChangeNotifier {
  OnboardingPageController() {
    carouselController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    carouselController.removeListener(notifyListeners);

    super.dispose();
  }

  final CarouselController carouselController = CarouselController();
}