// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      mongoId: json['_id'] as String,
      id: json['id'] as String,
      movieTitle: json['Title'] as String,
      movieYear: json['Year'] as String,
      movieRated: json['Rated'] as String,
      movieReleased: json['Released'] as String,
      movieRuntime: json['Runtime'] as String,
      movieGenre: json['Genre'] as String,
      movieDirector: json['Director'] as String,
      movieWriter: json['Writer'] as String,
      movieActors: json['Actors'] as String,
      moviePlot: json['Plot'] as String,
      movieLanguage: json['Language'] as String,
      movieCountry: json['Country'] as String,
      movieAwards: json['Awards'] as String,
      moviePoster: json['Poster'] as String,
      movieMetascore: json['Metascore'] as String,
      movieImdbRating: json['imdbRating'] as String,
      movieImdbVotes: json['imdbVotes'] as String,
      movieImdbID: json['imdbID'] as String,
      movieType: json['Type'] as String,
      movieResponse: json['Response'] as String,
      movieImages:
          (json['Images'] as List<dynamic>).map((e) => e as String).toList(),
      movieComingSoon: json['ComingSoon'] as bool,
      isFavorite: json['isFavorite'] as bool,
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isFavorite': instance.isFavorite,
      '_id': instance.mongoId,
      'Title': instance.movieTitle,
      'Year': instance.movieYear,
      'Rated': instance.movieRated,
      'Released': instance.movieReleased,
      'Runtime': instance.movieRuntime,
      'Genre': instance.movieGenre,
      'Director': instance.movieDirector,
      'Writer': instance.movieWriter,
      'Actors': instance.movieActors,
      'Plot': instance.moviePlot,
      'Language': instance.movieLanguage,
      'Country': instance.movieCountry,
      'Awards': instance.movieAwards,
      'Poster': instance.moviePoster,
      'Metascore': instance.movieMetascore,
      'imdbRating': instance.movieImdbRating,
      'imdbVotes': instance.movieImdbVotes,
      'imdbID': instance.movieImdbID,
      'Type': instance.movieType,
      'Response': instance.movieResponse,
      'Images': instance.movieImages,
      'ComingSoon': instance.movieComingSoon,
    };
