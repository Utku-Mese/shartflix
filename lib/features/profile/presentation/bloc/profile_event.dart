import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class LoadFavoriteMovies extends ProfileEvent {}

class RefreshProfile extends ProfileEvent {}

class UploadPhoto extends ProfileEvent {
  final File photo;

  const UploadPhoto(this.photo);

  @override
  List<Object?> get props => [photo];
}
