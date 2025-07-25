import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../../domain/usecases/favorite_usecases.dart';
import '../../../../core/services/firebase_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

@singleton
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;

  MovieBloc(
    this._getMoviesUseCase,
    this._addToFavoritesUseCase,
  ) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<ToggleMovieFavorite>(_onToggleMovieFavorite);
  }

  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<MovieState> emit,
  ) async {
    if (event.isRefresh || state is! MovieLoaded) {
      emit(MovieLoading());
    }

    final result = await _getMoviesUseCase.call(page: 1);

    result.fold(
      (movies) {
        // Movies loaded başarıyla yüklendiğinde analytics event'i
        FirebaseService.logEvent(
          name: 'movies_loaded',
          parameters: {
            'count': movies.length,
            'page': 1,
            'is_refresh': event.isRefresh ? 1 : 0,
          },
        );

        if (state is MovieLoaded) {
          final currentState = state as MovieLoaded;
          emit(currentState.copyWith(
            movies: movies,
            currentPage: 1,
            hasReachedMax: movies.length < 5,
          ));
        } else {
          emit(MovieLoaded(
            movies: movies,
            featuredMovies: const [],
            hasReachedMax: movies.length < 5,
            currentPage: 1,
          ));
        }
      },
      (error) {
        // Movie loading error'da Firebase'e error kaydet
        FirebaseService.recordError(
          exception: Exception('Movies loading failed: $error'),
          stackTrace: StackTrace.current,
          reason: 'Failed to load movies on page 1',
        );
        emit(MovieError(error));
      },
    );
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieState> emit,
  ) async {
    if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;

      if (currentState.hasReachedMax) return;

      final nextPage = currentState.currentPage + 1;
      final result = await _getMoviesUseCase.call(page: nextPage);

      result.fold(
        (movies) {
          // Load more movies analytics event'i
          FirebaseService.logEvent(
            name: 'movies_load_more',
            parameters: {
              'page': nextPage,
              'loaded_count': movies.length,
              'total_count': currentState.movies.length + movies.length,
            },
          );

          emit(currentState.copyWith(
            movies: List.from(currentState.movies)..addAll(movies),
            currentPage: nextPage,
            hasReachedMax: movies.length < 5,
          ));
        },
        (error) {
          // Load more error'da Firebase'e error kaydet
          FirebaseService.recordError(
            exception: Exception('Load more movies failed: $error'),
            stackTrace: StackTrace.current,
            reason: 'Failed to load more movies on page $nextPage',
          );
          emit(MovieError(error));
        },
      );
    }
  }

  Future<void> _onToggleMovieFavorite(
    ToggleMovieFavorite event,
    Emitter<MovieState> emit,
  ) async {
    // Favorite toggle başlatma analytics event'i
    FirebaseService.logEvent(
      name: 'movie_favorite_toggle',
      parameters: {
        'movie_id': event.movieId,
        'action': 'toggle_attempt',
      },
    );

    final result = await _addToFavoritesUseCase.call(event.movieId);

    result.fold(
      (success) {
        if (success) {
          // Başarılı favorite ekleme analytics event'i
          FirebaseService.logEvent(
            name: 'movie_favorite_added',
            parameters: {
              'movie_id': event.movieId,
              'success': true,
            },
          );

          emit(const MovieFavoriteUpdated(
            isSuccess: true,
            message: 'Film favorilere eklendi',
          ));
        } else {
          // Başarısız favorite ekleme analytics event'i
          FirebaseService.logEvent(
            name: 'movie_favorite_failed',
            parameters: {
              'movie_id': event.movieId,
              'success': false,
              'reason': 'unknown_error',
            },
          );

          emit(const MovieFavoriteUpdated(
            isSuccess: false,
            message: 'Bir hata oluştu',
          ));
        }
      },
      (error) {
        // Favorite error'da Firebase'e error kaydet
        FirebaseService.recordError(
          exception: Exception('Movie favorite toggle failed: $error'),
          stackTrace: StackTrace.current,
          reason: 'Failed to toggle favorite for movie: ${event.movieId}',
        );

        // Error analytics event'i
        FirebaseService.logEvent(
          name: 'movie_favorite_error',
          parameters: {
            'movie_id': event.movieId,
            'error_message': error,
          },
        );

        emit(MovieFavoriteUpdated(
          isSuccess: false,
          message: error,
        ));
      },
    );
  }
}
