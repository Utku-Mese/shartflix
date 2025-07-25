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
import '../../../../shared/widgets/movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MovieBloc _movieBloc;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _movieBloc = getIt<MovieBloc>();
    _movieBloc.add(const LoadMovies());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider<MovieBloc>.value(
      value: _movieBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(l10n.home),
          centerTitle: true,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<MovieBloc, MovieState>(
            listener: (context, state) {
              if (state is MovieError) {
                if (state.message.contains('TOKEN_UNAVAILABLE') ||
                    state.message.contains('TOKEN_EXPIRED') ||
                    state.message.contains('INVALID_TOKEN') ||
                    state.message.contains('Authentication failed') ||
                    state.message.contains('Access denied')) {
                  // Redirect to login
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              } else if (state is MovieFavoriteUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? ''),
                    backgroundColor:
                        state.isSuccess ? AppColors.success : AppColors.error,
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
                return _buildContent(state);
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
        bottomNavigationBar: _buildBottomNavigationBar(l10n),
      ),
    );
  }

  Widget _buildContent(MovieLoaded state) {
    return CustomScrollView(
      slivers: [
        // Featured Movie Section
        if (state.featuredMovies.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildFeaturedSection(state.featuredMovies.first),
          ),

        // Movies Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < state.movies.length) {
                  return MovieCard(
                    movie: state.movies[index],
                    style: MovieCardStyle.profile,
                    onTap: () {
                      // TODO: Navigate to movie detail
                    },
                  );
                } else if (!state.hasReachedMax) {
                  // Load more trigger
                  _movieBloc.add(LoadMoreMovies());
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFE53E3E),
                    ),
                  );
                }
                return null;
              },
              childCount: state.hasReachedMax
                  ? state.movies.length
                  : state.movies.length + 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(Movie movie) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image
          SizedBox(
            height: 500,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: movie.poster,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFF1A1A1A),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE53E3E),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFF1A1A1A),
                child: const Icon(
                  Icons.movie,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          ),

          // Gradient Overlay
          Container(
            height: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Movie Info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53E3E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.director,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Daha Fazlası',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    movie.plot,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Favorite Button
          Positioned(
            bottom: 120,
            right: 24,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _movieBloc.add(ToggleMovieFavorite(int.parse(movie.id)));
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: const Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? AppColors.cardBackground
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.home_outlined),
                  if (_currentIndex == 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      l10n.home,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _currentIndex == 1
                    ? AppColors.cardBackground
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outline),
                  if (_currentIndex == 1) ...[
                    const SizedBox(width: 8),
                    Text(
                      l10n.profile,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
