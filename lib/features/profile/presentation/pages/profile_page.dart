import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_bottom_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/profile_header.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ProfileBloc>.value(value: _profileBloc),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: AppColors.cardBackground,
          //       border: Border.all(
          //         color: AppColors.borderColor,
          //         width: 1,
          //       ),
          //     ),
          //     child: Icon(
          //       Icons.arrow_back,
          //       color: AppColors.textPrimary,
          //     ),
          //   ),
          // ),
          title: Text(
            l10n.profileDetails,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const PremiumBottomSheet(),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      l10n.limitedOffer,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profileState.message,
                            style: TextStyle(
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
                    ),
                  );
                },
              );
            },
          ),
        ),
        //bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildContent(ProfileLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        // Profile Header
        SliverToBoxAdapter(
          child: ProfileHeader(
            profile: state.profile,
            onAddPhotoTap: () async {
              final result =
                  await Navigator.pushNamed(context, '/photo-upload');
              if (result == true) {
                _profileBloc.add(RefreshProfile());
              }
            },
          ),
        ),

        // Section spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),

        // Favorite Movies Section
        SliverToBoxAdapter(
          child: SectionHeader(title: l10n.likedMovies),
        ),

        // Favorite Movies Grid
        FavoriteMoviesGrid(
          favoriteMovies: state.favoriteMovies,
        ),
      ],
    );
  }

  // Widget _buildBottomNavigationBar() {
  //   return Container(
  //     height: 80,
  //     decoration: BoxDecoration(
  //       color: theme.scaffoldBackgroundColor,
  //       border: Border(
  //         top: BorderSide(
  //           color: AppColors.borderColor,
  //           width: 0.5,
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: _buildNavItem(
  //             icon: SvgPicture.asset(
  //               'assets/icons/home_icon.svg',
  //               width: 24,
  //               height: 24,
  //             ),
  //             label: 'Anasayfa',
  //             isSelected: _currentIndex == 0,
  //             onTap: () {
  //               setState(() {
  //                 _currentIndex = 0;
  //               });
  //               Navigator.pushReplacementNamed(context, '/');
  //             },
  //           ),
  //         ),
  //         Expanded(
  //           child: _buildNavItem(
  //             icon: Icon(
  //               Icons.explore_outlined,
  //               size: 24,
  //               color: _currentIndex == 1
  //                   ? AppColors.textPrimary
  //                   : AppColors.textSecondary,
  //             ),
  //             label: 'Keşfet',
  //             isSelected: _currentIndex == 1,
  //             onTap: () {
  //               setState(() {
  //                 _currentIndex = 1;
  //               });
  //               Navigator.pushReplacementNamed(context, '/discover');
  //             },
  //           ),
  //         ),
  //         Expanded(
  //           child: _buildNavItem(
  //             icon: SvgPicture.asset(
  //               'assets/icons/profile_icon.svg',
  //               width: 24,
  //               height: 24,
  //             ),
  //             label: 'Profil',
  //             isSelected: _currentIndex == 2,
  //             onTap: () {
  //               setState(() {
  //                 _currentIndex = 2;
  //               });
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildNavItem({
  //   required Widget icon,
  //   required String label,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: isSelected ? AppColors.cardBackground : Colors.transparent,
  //         borderRadius: BorderRadius.circular(25),
  //         border: Border.all(
  //           color: isSelected
  //               ? AppColors.borderColor
  //               : AppColors.borderColor.withOpacity(0.3),
  //           width: 1,
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           icon,
  //           const SizedBox(width: 8),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //               color: isSelected
  //                   ? AppColors.textPrimary
  //                   : AppColors.textSecondary,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
