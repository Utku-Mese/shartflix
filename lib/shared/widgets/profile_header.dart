import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/profile/domain/entities/profile.dart';

class ProfileHeader extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onAddPhotoTap;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.onAddPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Profile Image
          _buildProfileImage(),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: _buildUserInfo(),
          ),
          // Add Photo Button
          _buildAddPhotoButton(l10n),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.borderColor,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profile.photoUrl ??
              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.cardBackground,
            child: Icon(
              Icons.person,
              color: AppColors.textSecondary,
              size: 32,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.cardBackground,
            child: Icon(
              Icons.person,
              color: AppColors.textSecondary,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.name.length > 8
              ? '${profile.name.substring(0, 8)}...'
              : profile.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: ${profile.id.substring(0, 8)}...',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onAddPhotoTap,
        child: Text(
          l10n.addPhoto,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
