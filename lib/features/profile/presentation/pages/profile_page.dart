import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/profile_header.dart';
import '../../../../shared/widgets/profile_actions.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/favorite_movies_grid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthBloc _authBloc;
  late ProfileBloc _profileBloc;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _profileBloc = getIt<ProfileBloc>();

    // Load profile data when page initializes
    _profileBloc.add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ProfileBloc>.value(value: _profileBloc),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardBackground,
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          title: Text(
            'Profil Detayı',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.diamond_outlined,
                    color: AppColors.textPrimary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sınırlı Teklif',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {},
            builder: (context, authState) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  if (profileState is ProfileLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (profileState is ProfileError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bir hata oluştu',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profileState.message,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              _profileBloc.add(RefreshProfile());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textPrimary,
                            ),
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (profileState is ProfileLoaded) {
                    return _buildContent(profileState);
                  }

                  return Center(
                    child: Text(
                      'Profil yükleniyor...',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildContent(ProfileLoaded state) {
    return CustomScrollView(
      slivers: [
        // Profile Header
        SliverToBoxAdapter(
          child: ProfileHeader(
            profile: state.profile,
            onAddPhotoTap: () {
              Navigator.pushNamed(context, '/photo-upload');
            },
          ),
        ),

        // Favorite Movies Section
        SliverToBoxAdapter(
          child: SectionHeader(title: 'Beğendiğim Filmler'),
        ),

        // Favorite Movies Grid
        FavoriteMoviesGrid(
          favoriteMovies: state.favoriteMovies,
          onMovieTap: (movie) {
            // TODO: Navigate to movie detail
          },
        ),
      ],
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
}
