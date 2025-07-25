import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/services/profile_api_service.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_favorite_movies_usecase.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../services/logger_service.dart';

// This module provides core services and dependencies for the application.

@module
abstract class CoreModule {
  @lazySingleton
  Dio provideDio() => Dio();

  @preResolve
  Future<SharedPreferences> provideSharedPreferences() =>
      SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage provideSecureStorage() => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  @lazySingleton
  Connectivity provideConnectivity() => Connectivity();

  @injectable
  ProfileApiService provideProfileApiService(Dio dio) => ProfileApiService(dio);

  @injectable
  ProfileBloc provideProfileBloc(
    GetProfileUseCase getProfileUseCase,
    GetFavoriteMoviesUseCase getFavoriteMoviesUseCase,
  ) =>
      ProfileBloc(
        getProfileUseCase,
        getFavoriteMoviesUseCase,
      );

  @Injectable(as: ProfileRepository)
  ProfileRepositoryImpl provideProfileRepository(
          ProfileApiService apiService, LoggerService logger) =>
      ProfileRepositoryImpl(apiService, logger);
}
