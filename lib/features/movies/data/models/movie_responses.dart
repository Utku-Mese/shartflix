import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'movie_model.dart';

part 'movie_responses.g.dart';

@JsonSerializable()
class MovieListData extends Equatable {
  final List<MovieModel> movies;
  final PaginationInfo pagination;

  const MovieListData({
    required this.movies,
    required this.pagination,
  });

  factory MovieListData.fromJson(Map<String, dynamic> json) =>
      _$MovieListDataFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListDataToJson(this);

  @override
  List<Object?> get props => [movies, pagination];
}

@JsonSerializable()
class PaginationInfo extends Equatable {
  final int totalCount;
  final int perPage;
  final int maxPage;
  final int currentPage;

  const PaginationInfo({
    required this.totalCount,
    required this.perPage,
    required this.maxPage,
    required this.currentPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationInfoToJson(this);

  @override
  List<Object?> get props => [totalCount, perPage, maxPage, currentPage];

  bool get hasNextPage => currentPage < maxPage;
  bool get hasPreviousPage => currentPage > 1;
  int get nextPage => hasNextPage ? currentPage + 1 : currentPage;
  int get previousPage => hasPreviousPage ? currentPage - 1 : currentPage;
}

@JsonSerializable()
class FavoriteActionData extends Equatable {
  final MovieModel movie;
  final String action; // "favorited" or "unfavorited"

  const FavoriteActionData({
    required this.movie,
    required this.action,
  });

  factory FavoriteActionData.fromJson(Map<String, dynamic> json) =>
      _$FavoriteActionDataFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteActionDataToJson(this);

  @override
  List<Object?> get props => [movie, action];

  bool get isFavorited => action == 'favorited';
  bool get isUnfavorited => action == 'unfavorited';
}
