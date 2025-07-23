import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'auth_requests.g.dart';

@JsonSerializable()
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object?> get props => [email, password];
}

@JsonSerializable()
class RegisterRequest extends Equatable {
  final String email;
  final String name;
  final String password;

  const RegisterRequest({
    required this.email,
    required this.name,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  List<Object?> get props => [email, name, password];
}

@JsonSerializable()
class UploadPhotoResponse extends Equatable {
  final String photoUrl;

  const UploadPhotoResponse({
    required this.photoUrl,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoResponseToJson(this);

  @override
  List<Object?> get props => [photoUrl];
}
