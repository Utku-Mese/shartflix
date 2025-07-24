import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MovieEvent {
  final bool isRefresh;

  const LoadMovies({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleMovieFavorite extends MovieEvent {
  final int movieId;

  const ToggleMovieFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
