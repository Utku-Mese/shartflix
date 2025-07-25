import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final List<Movie> favoriteMovies;

  const ProfileLoaded({
    required this.profile,
    required this.favoriteMovies,
  });

  @override
  List<Object?> get props => [profile, favoriteMovies];

  ProfileLoaded copyWith({
    Profile? profile,
    List<Movie>? favoriteMovies,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class PhotoUploading extends ProfileState {}

class PhotoUploadSuccess extends ProfileState {
  final Profile updatedProfile;

  const PhotoUploadSuccess(this.updatedProfile);

  @override
  List<Object?> get props => [updatedProfile];
}

class PhotoUploadError extends ProfileState {
  final String message;

  const PhotoUploadError(this.message);

  @override
  List<Object?> get props => [message];
}
