import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../core/constants/app_colors.dart';

enum MovieCardStyle { profile, home }

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showTitle;
  final bool showDirector;
  final MovieCardStyle style;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width,
    this.height,
    this.showTitle = true,
    this.showDirector = true,
    this.style = MovieCardStyle.profile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: style == MovieCardStyle.home
              ? AppColors.cardBackground
              : Colors.transparent,
        ),
        child: style == MovieCardStyle.home
            ? _buildHomeStyleCard()
            : _buildProfileStyleCard(),
      ),
    );
  }

  Widget _buildProfileStyleCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie Poster
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.cardBackground,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildPosterImage(),
            ),
          ),
        ),

        if (showTitle || showDirector) ...[
          const SizedBox(height: 12),
          // Movie Info
          if (showTitle)
            Text(
              movie.title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          if (showTitle && showDirector) const SizedBox(height: 4),

          if (showDirector)
            Text(
              movie.director,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ],
    );
  }

  Widget _buildHomeStyleCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          Expanded(
            flex: 3,
            child: SizedBox(
              width: double.infinity,
              child: _buildPosterImage(),
            ),
          ),

          // Movie Info
          if (showTitle || showDirector)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (showTitle)
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (showDirector)
                      Text(
                        movie.director,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPosterImage() {
    return CachedNetworkImage(
      imageUrl: movie.poster,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.cardBackground,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.cardBackground,
        child: Icon(
          Icons.movie,
          color: AppColors.textSecondary,
          size: 32,
        ),
      ),
    );
  }
}
