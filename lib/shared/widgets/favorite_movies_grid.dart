import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/movies/domain/entities/movie.dart';
import 'movie_card.dart';

class FavoriteMoviesGrid extends StatelessWidget {
  final List<Movie> favoriteMovies;

  const FavoriteMoviesGrid({
    super.key,
    required this.favoriteMovies,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteMovies.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState(),
      );
    }

    // Show maximum 8 movies in 2x2 grid
    final displayMovies = favoriteMovies.take(8).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final movie = displayMovies[index];
            return MovieCard(
              movie: movie,
            );
          },
          childCount: displayMovies.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz favori film eklenmemiş',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
