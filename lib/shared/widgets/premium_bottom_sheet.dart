import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 0.7,
          colors: [
            Color(0xFFE50914),
            Color(0xFF000000),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            const Text(
              'Sınırlı Teklif',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Jeton paketini seçerek bonus\nkazanın ve yeni bölümlerin kilidini açın!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 32),

            // Bonuses Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.6,
                  colors: [
                    AppColors.white.withOpacity(0.15),
                    AppColors.white.withOpacity(0.07),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Alacağınız Bonuslar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bonus Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBonusItem(
                        imagePath: 'assets/images/bonus/bonus1.png',
                        label: 'Premium\nHesap',
                        color: const Color(0xFFE91E63),
                      ),
                      _buildBonusItem(
                        imagePath: 'assets/images/bonus/bonus2.png',
                        label: 'Daha\nFazla Eşleşme',
                        color: const Color(0xFFE91E63),
                      ),
                      _buildBonusItem(
                        imagePath: 'assets/images/bonus/bonus3.png',
                        label: 'Öne\nÇıkarma',
                        color: const Color(0xFFE91E63),
                      ),
                      _buildBonusItem(
                        imagePath: 'assets/images/bonus/bonus4.png',
                        label: 'Daha\nFazla Beğeni',
                        color: const Color(0xFFE91E63),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Packages Section
            const Text(
              'Kilidi açmak için bir jeton paketi seçin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Package Cards
            Row(
              children: [
                Expanded(
                  child: _buildPackageCard(
                    discount: '+10%',
                    originalPrice: '299',
                    finalPrice: '1.090',
                    packagePrice: '₺99,99',
                    description: 'Başına haftalık',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPackageCard(
                    discount: '+70%',
                    originalPrice: '2.000',
                    finalPrice: '3.375',
                    packagePrice: '₺799,99',
                    description: 'Başına haftalık',
                    color: AppColors.primary,
                    isPopular: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPackageCard(
                    discount: '+35%',
                    originalPrice: '1.000',
                    finalPrice: '1.350',
                    packagePrice: '₺399,99',
                    description: 'Başına haftalık',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // All Tokens Button
            InkWell(
              onTap: () {
                // Handle tap
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Tüm Jetonları Gör',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusItem({
    required String imagePath,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(
              color: AppColors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard({
    required String discount,
    required String originalPrice,
    required String finalPrice,
    required String packagePrice,
    required String description,
    required Color color,
    bool isPopular = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Package Card
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.9,
                colors: [
                  isPopular
                      ? Color(0XFF5949E6)
                      : AppColors.primaryDark.withOpacity(0.7),
                  color,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),

                  // Original Price (crossed out)
                  Text(
                    originalPrice,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Final Price
                  Text(
                    finalPrice,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),

                  // Jeton text
                  const Text(
                    'Jeton',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Package Price
                  Text(
                    packagePrice,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Discount Badge
          Positioned(
            top: -6,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      isPopular ? Color(0XFF5949E6) : AppColors.primaryDark,
                      AppColors.white.withOpacity(0.6),
                    ],
                    center: Alignment.center,
                    radius: 3,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
