import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../../domain/usecases/get_featured_movies_usecase.dart';
import '../../domain/usecases/favorite_usecases.dart';
import 'movie_event.dart';
import 'movie_state.dart';

@injectable
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final GetFeaturedMoviesUseCase _getFeaturedMoviesUseCase;
  final AddToFavoritesUseCase _addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase _removeFromFavoritesUseCase;

  MovieBloc(
    this._getMoviesUseCase,
    this._getFeaturedMoviesUseCase,
    this._addToFavoritesUseCase,
    this._removeFromFavoritesUseCase,
  ) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<SearchMovies>(_onSearchMovies);
    on<LoadFeaturedMovies>(_onLoadFeaturedMovies);
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
        if (state is MovieLoaded) {
          final currentState = state as MovieLoaded;
          emit(currentState.copyWith(
            movies: movies,
            currentPage: 1,
            hasReachedMax: movies.length < 20,
          ));
        } else {
          emit(MovieLoaded(
            movies: movies,
            featuredMovies: const [],
            hasReachedMax: movies.length < 20,
            currentPage: 1,
          ));
        }
      },
      (error) => emit(MovieError(error)),
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
          emit(currentState.copyWith(
            movies: List.from(currentState.movies)..addAll(movies),
            currentPage: nextPage,
            hasReachedMax: movies.length < 20,
          ));
        },
        (error) => emit(MovieError(error)),
      );
    }
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    final result = await _getMoviesUseCase.call(
      page: 1,
      search: event.query.isNotEmpty ? event.query : null,
    );

    result.fold(
      (movies) {
        if (state is MovieLoaded) {
          final currentState = state as MovieLoaded;
          emit(currentState.copyWith(
            movies: movies,
            currentPage: 1,
            hasReachedMax: movies.length < 20,
          ));
        } else {
          emit(MovieLoaded(
            movies: movies,
            featuredMovies: const [],
            hasReachedMax: movies.length < 20,
            currentPage: 1,
          ));
        }
      },
      (error) => emit(MovieError(error)),
    );
  }

  Future<void> _onLoadFeaturedMovies(
    LoadFeaturedMovies event,
    Emitter<MovieState> emit,
  ) async {
    final result = await _getFeaturedMoviesUseCase.call();

    result.fold(
      (featuredMovies) {
        if (state is MovieLoaded) {
          final currentState = state as MovieLoaded;
          emit(currentState.copyWith(featuredMovies: featuredMovies));
        } else {
          emit(MovieLoaded(
            movies: const [],
            featuredMovies: featuredMovies,
            hasReachedMax: true,
            currentPage: 1,
          ));
        }
      },
      (error) => emit(MovieError(error)),
    );
  }

  Future<void> _onToggleMovieFavorite(
    ToggleMovieFavorite event,
    Emitter<MovieState> emit,
  ) async {
    // TODO: Implement actual favorite toggle logic
    // For now, we'll assume we're adding to favorites
    final result = await _addToFavoritesUseCase.call(event.movieId);

    result.fold(
      (success) {
        if (success) {
          emit(const MovieFavoriteUpdated(
            isSuccess: true,
            message: 'Film favorilere eklendi',
          ));
        } else {
          emit(const MovieFavoriteUpdated(
            isSuccess: false,
            message: 'Bir hata oluştu',
          ));
        }
      },
      (error) => emit(MovieFavoriteUpdated(
        isSuccess: false,
        message: error,
      )),
    );
  }
}
