import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: '_id')
  final String mongoId;
  final String token;

  const UserModel({
    required this.mongoId,
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
  }

  @override
  UserModel copyWith({
    String? mongoId,
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? token,
  }) {
    return UserModel(
      mongoId: mongoId ?? this.mongoId,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
    );
  }
}
