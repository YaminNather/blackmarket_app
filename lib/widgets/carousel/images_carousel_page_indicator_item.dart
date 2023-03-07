import 'package:flutter/material.dart';

class ImagesCarouselPageIndicatorItem extends StatelessWidget {
  const ImagesCarouselPageIndicatorItem(this.imageProvider, { required this.isSelected, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    
    final Color borderColor;
    final double imageOpacity;
    if(isSelected) {
      borderColor = theme.colorScheme.primary;
      imageOpacity = 1.0;      
    }
    else {
      borderColor = Colors.grey;
      imageOpacity = 0.5;
    }

    return Container(      
      decoration: BoxDecoration(border: Border.all(width: 2.0, color: borderColor)),
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: imageOpacity,
        child: Image(image: imageProvider)
      )
    );
  }

  final ImageProvider imageProvider;
  final bool isSelected;
}