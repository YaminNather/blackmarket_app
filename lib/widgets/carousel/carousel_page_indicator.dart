import 'dart:math';

import 'package:blackmarket_app/widgets/carousel/carousel_controller.dart';
import 'package:flutter/material.dart';

class CarouselPageIndicator extends StatefulWidget {
  const CarouselPageIndicator({ 
    Key? key, 
    required this.controller, 
    required this.pagesCount,
    this.maxCircleCount = 3,
  }) : super(key: key);

  @override
  State<CarouselPageIndicator> createState() => _CarouselPageIndicatorState();



  final CarouselController controller;
  final int pagesCount;
  final int maxCircleCount;
}

class _CarouselPageIndicatorState extends State<CarouselPageIndicator> {
  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    if(_controller != widget.controller)
      _switchController();

    final ThemeData theme = Theme.of(context);

    final int circleCount = min(widget.pagesCount, widget.maxCircleCount);

    final highlightedCircleIndex = _getHighlightedCircleIndex();
    
    List<Widget> circles = <Widget>[];
    for(int i = 0; i < circleCount; i++) {
      Color backgroundColor = (i != highlightedCircleIndex) ? theme.disabledColor : theme.colorScheme.primary;
      final Widget circle = _buildCircle(backgroundColor);
      circles.add(circle);
    }

    return Row(mainAxisSize: MainAxisSize.min, children: circles);
  }

  Widget _buildCircle(Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 8.0, height: 8.0,
        child: DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3000.0), color: backgroundColor)
        )
      ),
    );
  }

  int _getHighlightedCircleIndex() {
    final int currentPage = _controller.getCurrentPage();
    double highlightedCircleIndexDouble = (currentPage / widget.pagesCount);
    highlightedCircleIndexDouble *= widget.maxCircleCount - 1;    

    return highlightedCircleIndexDouble.round();
  }

  void _switchController() {
    _controller.removeListener(_update);

    _controller = widget.controller;
    _controller.addListener(_update);        
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_update);

    super.dispose();
  }


  late CarouselController _controller;
}