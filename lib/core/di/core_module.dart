import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class CoreModule {
  @lazySingleton
  Dio provideDio() => Dio();

  @preResolve
  Future<SharedPreferences> provideSharedPreferences() =>
      SharedPreferences.getInstance();
}
