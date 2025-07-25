import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../../domain/entities/movie.dart';
import '../../../../core/di/injection.dart';
import 'movie_detail_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late MovieBloc _movieBloc;
  late PageController _pageController;
  int _currentMovieIndex = 0;

  @override
  void initState() {
    super.initState();
    _movieBloc = getIt<MovieBloc>();
    _pageController = PageController();
    _movieBloc.add(const LoadMovies());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider<MovieBloc>.value(
      value: _movieBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<MovieBloc, MovieState>(
            listener: (context, state) {
              if (state is MovieError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is MovieFavoriteUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.isSuccess
                          ? (state.message ?? 'Film favorilere eklendi!')
                          : (state.message ?? 'Bir hata oluştu'),
                    ),
                    backgroundColor:
                        state.isSuccess ? AppColors.primary : Colors.red,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is MovieLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state is MovieLoaded) {
                return _buildDiscoverContent(state);
              }

              return Center(
                child: Text(
                  l10n.errorOccurred,
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverContent(MovieLoaded state) {
    if (state.movies.isEmpty) {
      return Center(
        child: Text(
          'Henüz film yok',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      );
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() {
          _currentMovieIndex = index;
        });

        // Load more movies when approaching the end
        if (index >= state.movies.length - 2 && !state.hasReachedMax) {
          _movieBloc.add(LoadMoreMovies());
        }
      },
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
        return _buildMovieCard(state.movies[index], index);
      },
    );
  }

  Widget _buildMovieCard(Movie movie, int movieIndex) {
    return Stack(
      children: [
        // Background Image - only show first image
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            imageUrl: movie.images.isNotEmpty ? movie.images[0] : movie.poster,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: const Color(0xFF1A1A1A),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              // Fallback to poster if image fails
              return CachedNetworkImage(
                imageUrl: movie.poster,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF1A1A1A),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          movie.title.isNotEmpty
                              ? movie.title[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        ),

        // Movie Info
        Positioned(
          bottom: 50,
          left: 20,
          right: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: movie.poster,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFF1A1A1A),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        movie.title.isNotEmpty
                            ? movie.title[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Director
                    Text(
                      'Yönetmen: ${movie.director}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Plot
                    Text(
                      movie.plot,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Side Actions
        Positioned(
          right: 12,
          bottom: 50,
          child: Column(
            children: [
              // Favorite Button
              _buildActionButton(
                icon: movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: movie.isFavorite ? Colors.red : Colors.white,
                onTap: () {
                  _movieBloc.add(ToggleMovieFavorite(movie.id));
                },
              ),
              const SizedBox(height: 20),

              // More Info Button
              _buildActionButton(
                icon: Icons.info_outline,
                color: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: getIt<MovieBloc>(),
                        child: MovieDetailPage(movie: movie),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}
