import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding_page_slide_data.dart';

class OnboardingPageSlide extends StatefulWidget {
  const OnboardingPageSlide({required this.index, required this.child, Key? key }) : super(key: key);

  @override
  State<OnboardingPageSlide> createState() => _OnboardingPageSlideState();

  final int index;
  final Widget child;
}

class _OnboardingPageSlideState extends State<OnboardingPageSlide> {
  @override
  Widget build(BuildContext context) {
    _controller.updateWidgetData(context, widget.index);

    print('Recording ');

    return Provider<OnboardingPageSlideData>(
      create: (context) => _controller..updateWidgetData(this.context, widget.index),
      child: widget.child
    );
  }  

  late final OnboardingPageSlideData _controller = OnboardingPageSlideData();
  
}