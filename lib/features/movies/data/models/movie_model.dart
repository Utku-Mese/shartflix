import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  @JsonKey(name: '_id')
  final String mongoId;

  @JsonKey(name: 'Title')
  final String movieTitle;

  @JsonKey(name: 'Year')
  final String movieYear;

  @JsonKey(name: 'Rated')
  final String movieRated;

  @JsonKey(name: 'Released')
  final String movieReleased;

  @JsonKey(name: 'Runtime')
  final String movieRuntime;

  @JsonKey(name: 'Genre')
  final String movieGenre;

  @JsonKey(name: 'Director')
  final String movieDirector;

  @JsonKey(name: 'Writer')
  final String movieWriter;

  @JsonKey(name: 'Actors')
  final String movieActors;

  @JsonKey(name: 'Plot')
  final String moviePlot;

  @JsonKey(name: 'Language')
  final String movieLanguage;

  @JsonKey(name: 'Country')
  final String movieCountry;

  @JsonKey(name: 'Awards')
  final String movieAwards;

  @JsonKey(name: 'Poster')
  final String moviePoster;

  @JsonKey(name: 'Metascore')
  final String movieMetascore;

  @JsonKey(name: 'imdbRating')
  final String movieImdbRating;

  @JsonKey(name: 'imdbVotes')
  final String movieImdbVotes;

  @JsonKey(name: 'imdbID')
  final String movieImdbID;

  @JsonKey(name: 'Type')
  final String movieType;

  @JsonKey(name: 'Response')
  final String movieResponse;

  @JsonKey(name: 'Images')
  final List<String> movieImages;

  @JsonKey(name: 'ComingSoon')
  final bool movieComingSoon;

  const MovieModel({
    required this.mongoId,
    required super.id,
    required this.movieTitle,
    required this.movieYear,
    required this.movieRated,
    required this.movieReleased,
    required this.movieRuntime,
    required this.movieGenre,
    required this.movieDirector,
    required this.movieWriter,
    required this.movieActors,
    required this.moviePlot,
    required this.movieLanguage,
    required this.movieCountry,
    required this.movieAwards,
    required this.moviePoster,
    required this.movieMetascore,
    required this.movieImdbRating,
    required this.movieImdbVotes,
    required this.movieImdbID,
    required this.movieType,
    required this.movieResponse,
    required this.movieImages,
    required this.movieComingSoon,
    required super.isFavorite,
  }) : super(
          title: movieTitle,
          year: movieYear,
          rated: movieRated,
          released: movieReleased,
          runtime: movieRuntime,
          genre: movieGenre,
          director: movieDirector,
          writer: movieWriter,
          actors: movieActors,
          plot: moviePlot,
          language: movieLanguage,
          country: movieCountry,
          awards: movieAwards,
          poster: moviePoster,
          metascore: movieMetascore,
          imdbRating: movieImdbRating,
          imdbVotes: movieImdbVotes,
          imdbID: movieImdbID,
          type: movieType,
          response: movieResponse,
          images: movieImages,
          comingSoon: movieComingSoon,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  Movie toEntity() {
    return Movie(
      id: id,
      title: movieTitle,
      year: movieYear,
      rated: movieRated,
      released: movieReleased,
      runtime: movieRuntime,
      genre: movieGenre,
      director: movieDirector,
      writer: movieWriter,
      actors: movieActors,
      plot: moviePlot,
      language: movieLanguage,
      country: movieCountry,
      awards: movieAwards,
      poster: moviePoster,
      metascore: movieMetascore,
      imdbRating: movieImdbRating,
      imdbVotes: movieImdbVotes,
      imdbID: movieImdbID,
      type: movieType,
      response: movieResponse,
      images: movieImages,
      comingSoon: movieComingSoon,
      isFavorite: isFavorite,
    );
  }
}
