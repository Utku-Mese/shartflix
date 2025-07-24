import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../movies/presentation/bloc/movie_bloc.dart';
import '../../../movies/presentation/bloc/movie_state.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../../core/di/injection.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthBloc _authBloc;
  late MovieBloc _movieBloc;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _movieBloc = getIt<MovieBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<MovieBloc>.value(value: _movieBloc),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
            },
            builder: (context, authState) {
              return CustomScrollView(
                slivers: [
                  // Profile Header
                  SliverToBoxAdapter(
                    child: _buildProfileHeader(),
                  ),

                  // Favorite Movies Section
                  SliverToBoxAdapter(
                    child: _buildSectionHeader('Beğendiğim Filmler'),
                  ),

                  // Favorite Movies Grid
                  _buildFavoriteMoviesGrid(),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Sınırlı Teklif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Profile Info
          Row(
            children: [
              // Profile Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF333333),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 32,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white54,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ayça Aydoğan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ID: 245677',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Add Photo Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/photo-upload');
                  },
                  child: const Text(
                    'Fotoğraf Ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profile Actions
          Row(
            children: [
              Expanded(
                child: _buildProfileAction(
                  icon: Icons.edit_outlined,
                  label: 'Profili Düzenle',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProfileAction(
                  icon: Icons.logout,
                  label: 'Çıkış Yap',
                  onTap: () {
                    _authBloc.add(LogoutRequested());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFavoriteMoviesGrid() {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        final demoMovies = _getDemoMovies();

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < demoMovies.length) {
                  return _buildMovieCard(demoMovies[index]);
                }
                return null;
              },
              childCount: demoMovies.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A1A),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: movie.poster,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE53E3E),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // Movie Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      movie.director,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
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
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
        border: Border(
          top: BorderSide(
            color: Color(0xFF333333),
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pop(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? const Color(0xFF1A1A1A)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.home_outlined),
                  if (_currentIndex == 0) ...[
                    const SizedBox(width: 8),
                    const Text(
                      'Anasayfa',
                      style: TextStyle(fontSize: 12),
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
                    ? const Color(0xFF1A1A1A)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outline),
                  if (_currentIndex == 1) ...[
                    const SizedBox(width: 8),
                    const Text(
                      'Profil',
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

  List<Movie> _getDemoMovies() {
    return [
      const Movie(
        id: '1',
        title: 'Aşk, Ekmek, Hayaller',
        year: '2023',
        rated: 'PG-13',
        released: '2023-01-01',
        runtime: '120 min',
        genre: 'Romance, Drama',
        director: 'Adam Yapım',
        writer: 'Writer 1',
        actors: 'Actor 1, Actor 2',
        plot: 'A beautiful romantic story',
        language: 'Turkish',
        country: 'Turkey',
        awards: 'N/A',
        poster:
            'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=400&h=600&fit=crop',
        metascore: '85',
        imdbRating: '8.5',
        imdbVotes: '1000',
        imdbID: 'tt1234567',
        type: 'movie',
        response: 'True',
        images: [],
        comingSoon: false,
        isFavorite: true,
      ),
      const Movie(
        id: '2',
        title: 'Gece Karanlık',
        year: '2023',
        rated: 'R',
        released: '2023-02-01',
        runtime: '110 min',
        genre: 'Thriller, Drama',
        director: 'Fox Studios',
        writer: 'Writer 2',
        actors: 'Actor 3, Actor 4',
        plot: 'A thrilling dark story',
        language: 'Turkish',
        country: 'Turkey',
        awards: 'N/A',
        poster:
            'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=400&h=600&fit=crop',
        metascore: '78',
        imdbRating: '7.8',
        imdbVotes: '800',
        imdbID: 'tt2345678',
        type: 'movie',
        response: 'True',
        images: [],
        comingSoon: false,
        isFavorite: true,
      ),
    ];
  }
}
