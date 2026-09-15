import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../theme/app_theme.dart';

class FeaturedDishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback? onTap;

  const FeaturedDishCard({super.key, required this.dish, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.black,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              dish.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.blackSoft,
                child: const Center(
                  child: Icon(Icons.restaurant, size: 48, color: Colors.white54),
                ),
              ),
            ),
            // Voile dégradé pour garder le texte lisible sur la photo.
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0), Colors.black.withValues(alpha: 0.65)],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plat du jour',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.goldLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dish.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${dish.price} FCFA',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
