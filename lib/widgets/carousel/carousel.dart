import 'package:blackmarket_app/widgets/carousel/carousel_controller.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  factory Carousel({CarouselController? controller, ScrollPhysics? physics, required List<Widget> children}) {
    final CarouselController finalController = controller ?? CarouselController();

    final PageView pageView = PageView(
      controller: finalController.pageController,
      physics: physics,
      children: children
    );

    return Carousel._(controller: controller, physics: physics, pageView: pageView, pageCount: children.length);
  }

  factory Carousel.builder({CarouselController? controller, ScrollPhysics? physics, required int itemCount, required Widget Function(BuildContext context, int index) itemBuilder}) {
    final CarouselController finalController = controller ?? CarouselController();

    final PageView pageView = PageView.builder(
      controller: finalController.pageController,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: itemBuilder
    );

    return Carousel._(controller: controller, physics: physics, pageView: pageView, pageCount: itemCount);
  }

  const Carousel._({
    Key? key,
    this.controller,
    this.physics,
    required this.pageView,
    required this.pageCount
  }) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();


  final CarouselController? controller;
  final ScrollPhysics? physics;
  final Widget pageView;
  final int pageCount;
}

class _CarouselState extends State<Carousel> {
  @override
  void initState() {
    super.initState();

    if(widget.controller != null)
      controller = widget.controller!;
    else
      controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    controller.updateWidgetData(widget.pageCount);

    if(widget.controller != null && widget.controller != controller)
      controller = widget.controller!;

    return widget.pageView;
  }


  late CarouselController controller;
}