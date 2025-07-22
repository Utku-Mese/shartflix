// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:shartflix/core/di/core_module.dart' as _i1006;
import 'package:shartflix/core/network/api_client.dart' as _i325;
import 'package:shartflix/core/services/localization_service.dart' as _i1013;
import 'package:shartflix/core/services/logger_service.dart' as _i12;
import 'package:shartflix/core/services/secure_storage_service.dart' as _i313;
import 'package:shartflix/core/services/theme_service.dart' as _i32;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final coreModule = _$CoreModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreModule.provideSharedPreferences(),
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => coreModule.provideDio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => coreModule.provideSecureStorage());
    gh.lazySingleton<_i12.LoggerService>(() => _i12.LoggerService());
    gh.lazySingleton<_i1013.LocalizationService>(
        () => _i1013.LocalizationService(
              gh<_i460.SharedPreferences>(),
              gh<_i12.LoggerService>(),
            ));
    gh.lazySingleton<_i32.ThemeService>(() => _i32.ThemeService(
          gh<_i460.SharedPreferences>(),
          gh<_i12.LoggerService>(),
        ));
    gh.factory<_i325.ApiClient>(() => _i325.ApiClient(
          gh<_i361.Dio>(),
          gh<_i460.SharedPreferences>(),
        ));
    gh.lazySingleton<_i313.SecureStorageService>(
        () => _i313.SecureStorageService(
              gh<_i558.FlutterSecureStorage>(),
              gh<_i12.LoggerService>(),
            ));
    return this;
  }
}

class _$CoreModule extends _i1006.CoreModule {}
