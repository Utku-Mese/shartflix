import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final ResponseInfo response;
  final T? data;

  const ApiResponse({
    required this.response,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  bool get isSuccess => response.code >= 200 && response.code < 300;
  bool get isError => !isSuccess;
}

@JsonSerializable()
class ResponseInfo {
  final int code;
  final String message;

  const ResponseInfo({
    required this.code,
    required this.message,
  });

  factory ResponseInfo.fromJson(Map<String, dynamic> json) =>
      _$ResponseInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseInfoToJson(this);
}
