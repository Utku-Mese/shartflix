import 'package:injectable/injectable.dart';
import '../../../features/auth/domain/usecases/login_usecase.dart';
import '../../../features/auth/domain/usecases/register_usecase.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/movies/domain/usecases/get_movies_usecase.dart';
import '../../../features/movies/domain/usecases/get_featured_movies_usecase.dart';
import '../../../features/movies/domain/usecases/favorite_usecases.dart';

@module
abstract class UseCaseModule {
  // Auth Use Cases are already @injectable

  // Movie Use Cases are already @injectable
}

@module
abstract class BlocModule {
  // Auth Bloc is already @injectable
}
