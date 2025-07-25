import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../../features/movies/presentation/pages/home_page.dart';
import '../../features/movies/presentation/pages/discover_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  late PageController _pageController;

  final List<Widget> _pages = [
    const HomePage(),
    const DiscoverPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(l10n),
    );
  }

  Widget _buildBottomNavigationBar(AppLocalizations l10n) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavItem(
              icon: SvgPicture.asset(
                'assets/icons/home_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _currentIndex == 0
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              label: l10n.home,
              isSelected: _currentIndex == 0,
              onTap: () => _onNavItemTapped(0),
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: Icon(
                Icons.explore_outlined,
                size: 24,
                color: _currentIndex == 1
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              label: 'Keşfet',
              isSelected: _currentIndex == 1,
              onTap: () => _onNavItemTapped(1),
            ),
          ),
          Expanded(
            child: _buildNavItem(
              icon: SvgPicture.asset(
                'assets/icons/profile_icon.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  _currentIndex == 2
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              label: l10n.profile,
              isSelected: _currentIndex == 2,
              onTap: () => _onNavItemTapped(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required Widget icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? AppColors.borderColor
                : AppColors.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            icon,
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
