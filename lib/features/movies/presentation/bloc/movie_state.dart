import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final List<Movie> featuredMovies;
  final bool hasReachedMax;
  final int currentPage;

  const MovieLoaded({
    required this.movies,
    required this.featuredMovies,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object?> get props =>
      [movies, featuredMovies, hasReachedMax, currentPage];

  MovieLoaded copyWith({
    List<Movie>? movies,
    List<Movie>? featuredMovies,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      featuredMovies: featuredMovies ?? this.featuredMovies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieFavoriteUpdated extends MovieState {
  final bool isSuccess;
  final String? message;

  const MovieFavoriteUpdated({
    required this.isSuccess,
    this.message,
  });

  @override
  List<Object?> get props => [isSuccess, message];
}
