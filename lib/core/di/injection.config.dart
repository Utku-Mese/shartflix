// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:shartflix/core/di/core_module.dart' as _i1006;
import 'package:shartflix/core/di/network_module.dart' as _i408;
import 'package:shartflix/core/network/api_client.dart' as _i325;
import 'package:shartflix/core/network/services/auth_api_service.dart' as _i102;
import 'package:shartflix/core/network/services/movie_api_service.dart'
    as _i421;
import 'package:shartflix/core/services/connectivity_service.dart' as _i505;
import 'package:shartflix/core/services/localization_service.dart' as _i1013;
import 'package:shartflix/core/services/logger_service.dart' as _i12;
import 'package:shartflix/core/services/secure_storage_service.dart' as _i313;
import 'package:shartflix/core/services/theme_service.dart' as _i32;
import 'package:shartflix/features/auth/data/repositories/auth_repository_impl.dart'
    as _i689;
import 'package:shartflix/features/auth/domain/repositories/auth_repository.dart'
    as _i291;
import 'package:shartflix/features/auth/domain/usecases/login_usecase.dart'
    as _i539;
import 'package:shartflix/features/auth/domain/usecases/register_usecase.dart'
    as _i1049;
import 'package:shartflix/features/auth/presentation/bloc/auth_bloc.dart'
    as _i359;
import 'package:shartflix/features/movies/data/repositories/movie_repository_impl.dart'
    as _i343;
import 'package:shartflix/features/movies/domain/repositories/movie_repository.dart'
    as _i1003;
import 'package:shartflix/features/movies/domain/usecases/favorite_usecases.dart'
    as _i198;
import 'package:shartflix/features/movies/domain/usecases/get_movies_usecase.dart'
    as _i854;
import 'package:shartflix/features/movies/presentation/bloc/movie_bloc.dart'
    as _i418;

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
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => coreModule.provideSharedPreferences(),
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(() => coreModule.provideDio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => coreModule.provideSecureStorage());
    gh.lazySingleton<_i895.Connectivity>(
        () => coreModule.provideConnectivity());
    gh.lazySingleton<_i12.LoggerService>(() => _i12.LoggerService());
    gh.factory<_i505.ConnectivityService>(() => _i505.ConnectivityService(
          gh<_i895.Connectivity>(),
          gh<_i12.LoggerService>(),
        ));
    gh.lazySingleton<_i1013.LocalizationService>(
        () => _i1013.LocalizationService(
              gh<_i460.SharedPreferences>(),
              gh<_i12.LoggerService>(),
            ));
    gh.lazySingleton<_i32.ThemeService>(() => _i32.ThemeService(
          gh<_i460.SharedPreferences>(),
          gh<_i12.LoggerService>(),
        ));
    gh.lazySingleton<_i313.SecureStorageService>(
        () => _i313.SecureStorageService(
              gh<_i558.FlutterSecureStorage>(),
              gh<_i12.LoggerService>(),
            ));
    gh.factory<_i325.ApiClient>(() => _i325.ApiClient(
          gh<_i361.Dio>(),
          gh<_i313.SecureStorageService>(),
          gh<_i12.LoggerService>(),
          gh<_i505.ConnectivityService>(),
        ));
    gh.lazySingleton<_i102.AuthApiService>(
        () => networkModule.authApiService(gh<_i325.ApiClient>()));
    gh.lazySingleton<_i421.MovieApiService>(
        () => networkModule.movieApiService(gh<_i325.ApiClient>()));
    gh.lazySingleton<_i1003.MovieRepository>(() => _i343.MovieRepositoryImpl(
          gh<_i421.MovieApiService>(),
          gh<_i12.LoggerService>(),
        ));
    gh.factory<_i854.GetMoviesUseCase>(
        () => _i854.GetMoviesUseCase(gh<_i1003.MovieRepository>()));
    gh.factory<_i198.ToggleFavoriteUseCase>(
        () => _i198.ToggleFavoriteUseCase(gh<_i1003.MovieRepository>()));
    gh.factory<_i198.GetFavoriteMoviesUseCase>(
        () => _i198.GetFavoriteMoviesUseCase(gh<_i1003.MovieRepository>()));
    gh.lazySingleton<_i291.AuthRepository>(() => _i689.AuthRepositoryImpl(
          gh<_i102.AuthApiService>(),
          gh<_i313.SecureStorageService>(),
          gh<_i12.LoggerService>(),
        ));
    gh.factory<_i1049.RegisterUseCase>(
        () => _i1049.RegisterUseCase(gh<_i291.AuthRepository>()));
    gh.factory<_i539.LoginUseCase>(
        () => _i539.LoginUseCase(gh<_i291.AuthRepository>()));
    gh.factory<_i198.AddToFavoritesUseCase>(
        () => _i198.AddToFavoritesUseCase(gh<_i1003.MovieRepository>()));
    gh.factory<_i418.MovieBloc>(() => _i418.MovieBloc(
          gh<_i854.GetMoviesUseCase>(),
          gh<_i198.AddToFavoritesUseCase>(),
        ));
    gh.factory<_i359.AuthBloc>(() => _i359.AuthBloc(
          gh<_i539.LoginUseCase>(),
          gh<_i1049.RegisterUseCase>(),
          gh<_i313.SecureStorageService>(),
        ));
    return this;
  }
}

class _$CoreModule extends _i1006.CoreModule {}

class _$NetworkModule extends _i408.NetworkModule {}
