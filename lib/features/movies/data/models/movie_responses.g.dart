// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieListData _$MovieListDataFromJson(Map<String, dynamic> json) =>
    MovieListData(
      movies: (json['movies'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationInfo.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MovieListDataToJson(MovieListData instance) =>
    <String, dynamic>{
      'movies': instance.movies,
      'pagination': instance.pagination,
    };

PaginationInfo _$PaginationInfoFromJson(Map<String, dynamic> json) =>
    PaginationInfo(
      totalCount: (json['totalCount'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      maxPage: (json['maxPage'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationInfoToJson(PaginationInfo instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'perPage': instance.perPage,
      'maxPage': instance.maxPage,
      'currentPage': instance.currentPage,
    };

FavoriteActionData _$FavoriteActionDataFromJson(Map<String, dynamic> json) =>
    FavoriteActionData(
      movie: MovieModel.fromJson(json['movie'] as Map<String, dynamic>),
      action: json['action'] as String,
    );

Map<String, dynamic> _$FavoriteActionDataToJson(FavoriteActionData instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'action': instance.action,
    };
