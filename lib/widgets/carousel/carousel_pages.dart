import 'package:flutter/material.dart';

class CarouselPages extends StatefulWidget {
  const CarouselPages({ 
    Key? key,
    this.controller,
    this.physics,
    required this.itemBuilder, 
    required this.itemCount, 
    this.circleCount = 3
  }) : super(key: key);

  @override
  State<CarouselPages> createState() => _CarouselPagesState();

  final PageController? controller;
  final ScrollPhysics? physics;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int circleCount;
}

class _CarouselPagesState extends State<CarouselPages> {
  @override
  void initState() {
    super.initState();

    if(widget.controller != null)
      controller = widget.controller!;
    else
      controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.controller != null && widget.controller != controller)
      controller = widget.controller!;

    return Column(
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: controller,
            physics: widget.physics,
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder
          )
        )
      ]
    );
  }


  late PageController controller;
}