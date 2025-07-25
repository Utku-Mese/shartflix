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
import 'movie_detail_page.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  late MovieBloc _movieBloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _movieBloc = getIt<MovieBloc>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _movieBloc.add(const LoadMovies());
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _movieBloc.add(LoadMoreMovies());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
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
      ),
    );
  }

  Widget _buildContent(MovieLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        _movieBloc.add(const LoadMovies(isRefresh: true));
      },
      color: AppColors.primary,
      backgroundColor: AppColors.cardBackground,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Featured Movie Section
          if (state.movies.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildFeaturedSection(
                  state.movies[Random().nextInt(state.movies.length)]),
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
                    );
                  }
                  return null;
                },
                childCount: state.movies.length,
              ),
            ),
          ),

          // Loading Indicator at bottom
          if (!state.hasReachedMax)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

          // End message when all movies are loaded
          if (state.hasReachedMax && state.movies.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Tüm filmler yüklendi',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
              imageUrl: movie.images[Random().nextInt(movie.images.length)],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xFF1A1A1A),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE53E3E),
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                // İlk seçenek başarısız olursa alternatif dene
                String? fallbackUrl;
                if (movie.images.isNotEmpty && movie.images.length > 4) {
                  // İlk seçenek images[4] idi, poster'ı dene
                  fallbackUrl = movie.poster;
                } else {
                  // İlk seçenek poster idi, images.first'ü dene
                  fallbackUrl =
                      movie.images.isNotEmpty ? movie.images.first : null;
                }

                if (fallbackUrl != null) {
                  return CachedNetworkImage(
                    imageUrl: fallbackUrl,
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
                  );
                }

                return Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white54,
                    size: 64,
                  ),
                );
              },
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
                      GestureDetector(
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
                        child: Text(
                          'Daha Fazlası',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
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
        ],
      ),
    );
  }
}
