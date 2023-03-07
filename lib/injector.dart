import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase/supabase.dart';

import 'injector.config.dart';


final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);

@module
abstract class BackendClientModule {
  Client get client => _client;  

  final Client _client = Client.instance;  
}

@module
abstract class SupabaseClientModule {
  SupabaseClient getService() {
    const String url = 'https://nzjzbovrzkimbccsxptb.supabase.co';
    // const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56anpib3ZyemtpbWJjY3N4cHRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDQ4MjMxMjYsImV4cCI6MTk2MDM5OTEyNn0.lK9nCdpWSlIsRy1TAtnUS4ttfBLhd3l1AN2Y0XPGIm4';
    const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56anpib3ZyemtpbWJjY3N4cHRiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY0NDgyMzEyNiwiZXhwIjoxOTYwMzk5MTI2fQ.JwlSQBQGEV5EdV8dF5QY4fiEnPidSRKLMEg-JxB_75k';
    final SupabaseClient r = SupabaseClient(url, apiKey);
    return r;
  }  
}