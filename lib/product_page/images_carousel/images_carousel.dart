import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/widgets/carousel/carousel.dart';
import 'package:blackmarket_app/widgets/carousel/images_carousel_page_indicator.dart';
import 'package:flutter/material.dart';

import '../../widgets/carousel/carousel_controller.dart';
import '../../widgets/carousel/images_carousel_page_indicator_item.dart';

class ImagesCarousel extends StatelessWidget {
  ImagesCarousel({ Key? key, required this.product }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final List<String> images = [ product.mainImage ];
    // if(product.images != null)
    //   images.addAll(product.images!);

    final List<String> images = List<String>.filled(5, product.mainImage);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 256.0,
          child: Carousel.builder(
            controller: _controller,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image(image: NetworkImage(images[index]))
              );
            }
          )
        ),

        const SizedBox(height: 8.0),

        SizedBox(
          height: 48.0,
          child: ImagesCarouselPageIndicator(
            controller: _controller, 
            imagesCount: images.length,
            imageBuilder: (index, isSelected) {
              return SizedBox(
                width: 64.0,
                child: ImagesCarouselPageIndicatorItem(NetworkImage(images[index]), isSelected: isSelected)
              );
            }
          ),
        )
      ]
    );
  }



  final CarouselController _controller = CarouselController();

  final Product product;  
}