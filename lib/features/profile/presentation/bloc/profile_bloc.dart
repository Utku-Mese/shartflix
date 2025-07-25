import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_favorite_movies_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final GetFavoriteMoviesUseCase _getFavoriteMoviesUseCase;

  ProfileBloc(
    this._getProfileUseCase,
    this._getFavoriteMoviesUseCase,
  ) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Load profile first
      final profileResult = await _getProfileUseCase.call();

      if (profileResult.isErr) {
        emit(ProfileError(profileResult.errOrNull.toString()));
        return;
      }

      final profile = profileResult.okOrNull!;

      // If profile loaded successfully, load favorite movies
      final favoriteMoviesResult = await _getFavoriteMoviesUseCase.call();

      if (favoriteMoviesResult.isErr) {
        emit(ProfileError(favoriteMoviesResult.errOrNull.toString()));
        return;
      }

      final favoriteMovies = favoriteMoviesResult.okOrNull!;

      if (!emit.isDone) {
        emit(ProfileLoaded(
          profile: profile,
          favoriteMovies: favoriteMovies,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;

      final result = await _getFavoriteMoviesUseCase.call();

      if (result.isErr) {
        emit(ProfileError(result.errOrNull.toString()));
        return;
      }

      final favoriteMovies = result.okOrNull!;

      if (!emit.isDone) {
        emit(currentState.copyWith(favoriteMovies: favoriteMovies));
      }
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Trigger a fresh load
    add(LoadProfile());
  }
}
