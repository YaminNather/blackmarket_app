// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:blackmarket_backend_client/blackmarket_backend_client.dart'
    as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:supabase/supabase.dart' as _i4;

import 'injector.dart' as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final backendClientModule = _$BackendClientModule();
  final supabaseClientModule = _$SupabaseClientModule();
  gh.factory<_i3.Client>(() => backendClientModule.client);
  gh.factory<_i4.SupabaseClient>(() => supabaseClientModule.getService());
  return get;
}

class _$BackendClientModule extends _i5.BackendClientModule {}

class _$SupabaseClientModule extends _i5.SupabaseClientModule {}
