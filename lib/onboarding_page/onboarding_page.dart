import 'package:blackmarket_app/onboarding_page/onboarding_page_controller.dart';
import 'package:blackmarket_app/onboarding_page/onboarding_page_scroll_speed_adjuster.dart';
import 'package:blackmarket_app/widgets/carousel/carousel.dart';
import 'package:blackmarket_app/widgets/carousel/carousel_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_or_authentication_redirector/login_or_authentication_redirector.dart';
import 'current_slide_indicator.dart';
import 'fixed_onboarding_page_slide.dart';
import 'onboarding_page_slide.dart';
import 'slides/delivery_slide.dart';
import 'slides/from_the_comfort_of_your_home_slide.dart';
import 'slides/purchase_shoes_slide.dart';
import 'slides/sell_products_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({ Key? key }) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();

    _controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingPageController>(
      create: (context) => _controller,
      child: Scaffold(body: _buildBody())
    );
  }

  Widget _buildBody() {
    return Consumer<OnboardingPageController>(
      builder:(context, value, child) {        
        final Size screenSize = MediaQuery.of(context).size;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenSize.height * 0.8,
                child: Carousel(
                  controller: _controller.carouselController,
                  children: _slides
                )
              ),

              const SizedBox(height: 16.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const CurrentSlideIndicator(),
                    // CarouselPageIndicator(controller: _controller.carouselController, pagesCount: 3),

                    _buildGetStartedButton()
                  ]
                )
              )
            ]
          )
        ); 
      }      
    );
  }

  Widget _buildGetStartedButton() {
    final int currentSlide = _controller.carouselController.getCurrentPage();
    if(currentSlide != _slides.length - 1)
      return const SizedBox.shrink();

    return ElevatedButton(
      child: const Text('Get Started'), 
      onPressed: () async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setBool('first_launch', false);

        final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const LoginOrAuthenticationRedirector());
        Navigator.of(context).pushReplacement(route);
      }
    );
  }

  void _update() => setState(() {});

  static List<Widget> get _slides => <Widget>[
    PurchaseShoesSlide(index: 0),

    SellProductsSlide(index: 1),

    FromTheComfortOfYourHomeSlide(index: 2),

    DeliverySlide(index: 3)
  ];

  @override
  void dispose() {
    _controller.removeListener(_update);

    super.dispose();
  }


  late final OnboardingPageController _controller = OnboardingPageController();
}