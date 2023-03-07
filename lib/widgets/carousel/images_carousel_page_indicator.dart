import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'carousel_controller.dart';

class ImagesCarouselPageIndicator extends StatefulWidget {
  const ImagesCarouselPageIndicator({ Key? key, required this.controller, required this.imagesCount, required this.imageBuilder }) : super(key: key);

  @override
  State<ImagesCarouselPageIndicator> createState() => _ImagesCarouselPageIndicatorState();


  final CarouselController controller;
  final int imagesCount;
  final Widget Function(int index, bool isSelected) imageBuilder;
}

class _ImagesCarouselPageIndicatorState extends State<ImagesCarouselPageIndicator> {
  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.controller != _controller) {
      _controller.removeListener(_update);
      
      _controller = widget.controller;
      _controller.addListener(_update);
    }

    final int currentPageIndex = widget.controller.getCurrentPage();

    return ChangeNotifierProvider(
      create: (context) => widget.controller,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: widget.imagesCount,
        scrollDirection: Axis.horizontal,      
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => widget.controller.animateToPage(index),
            child: widget.imageBuilder(index, index == currentPageIndex)
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 16.0)
      ),
    );
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_update);

    super.dispose();
  }


  late CarouselController _controller;
}