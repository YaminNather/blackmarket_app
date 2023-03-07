import 'package:blackmarket_app/login_or_authentication_redirector/login_or_authentication_redirector.dart';
import 'package:blackmarket_app/onboarding_page/onboarding_page.dart';
import 'package:blackmarket_app/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingOrAuthenticationRedirector extends StatefulWidget {
  const OnboardingOrAuthenticationRedirector({ Key? key }) : super(key: key);

  @override
  State<OnboardingOrAuthenticationRedirector> createState() => _OnboardingOrAuthenticationRedirectorState();
}

class _OnboardingOrAuthenticationRedirectorState extends State<OnboardingOrAuthenticationRedirector> {
  @override
  void initState() {
    super.initState();

    _redirect();
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator();
  }

  Future<void> _redirect() async {
    final Widget page;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(!sharedPreferences.containsKey('first_launch'))
      page = const OnboardingPage();
    else {
      final bool firstTimeLaunch = sharedPreferences.getBool('first_launch')!;
      page = (firstTimeLaunch) ? const OnboardingPage() : const LoginOrAuthenticationRedirector();
    }

    final MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.of(context).pushReplacement(route);
  }
}