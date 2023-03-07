import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/app.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Client.initialize();  
  configureDependencies();

  runApp(const App());
}