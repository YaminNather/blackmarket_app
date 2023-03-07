import 'package:flutter/material.dart';

import 'onboarding_page_scroll_speed_adjuster.dart';
import 'onboarding_page_slide.dart';

class FixedOnboardingPageSlide extends StatefulWidget {
  const FixedOnboardingPageSlide({ 
    Key? key, 
    required this.index, 
    required this.title, 
    required this.description, 
    required this.upper
  }) : super(key: key);

  @override
  State<FixedOnboardingPageSlide> createState() => _FixedOnboardingPageSlideState();


  final int index;
  final Widget upper;
  final String title;
  final String description;
}

class _FixedOnboardingPageSlideState extends State<FixedOnboardingPageSlide> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return OnboardingPageSlide(
      index: widget.index,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OnboardingPageScrollSpeedAdjuster(
                      speedMultiplier: 8.0,
                      child: Align(alignment: Alignment.bottomCenter, child: widget.upper)
                    ),
                  )
                ),

                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OnboardingPageScrollSpeedAdjuster(
                        speedMultiplier: 2.0,
                        child: Text(widget.title, style: theme.textTheme.headline5, textAlign: TextAlign.center)
                      ),

                      const SizedBox(height: 16.0),

                      Text(widget.description, textAlign: TextAlign.center)
                    ]
                  )
                )
              ]
            )
          );
        }
      ),
    );
  }
}