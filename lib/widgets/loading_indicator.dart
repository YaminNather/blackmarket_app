import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({ Key? key }) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  void initState() {
    super.initState();

    final int index = Random().nextInt(_loadingIndicatorFiles.length);
    _loadingIndicatorFile = _loadingIndicatorFiles[index];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Lottie.asset('assets/loading_indicators/$_loadingIndicatorFile.json'),

        const SizedBox(height: 32.0),

        // TweenAnimationBuilder<double>(
        //   tween: Tween<double>(begin: 0.0, end: 1.0),
        //   duration: const Duration(milliseconds: 1000),
        //   curve: Curves.easeInOut,
        //   builder: (context, value, child) {
        //     return Transform.scale(
        //       scale: value,
        //       child: Text('Some Random Loading Quote', style: theme.textTheme.headline6)
        //     );
        //   }
        // )
      ]
    );
    // return const LoadingIndicator();
  }

  late final String _loadingIndicatorFile;


  static const List<String> _loadingIndicatorFiles = <String>[
    // 'roller_skates_loading_indicator',
    'walking_shoes_loading_indicator'
  ];
}