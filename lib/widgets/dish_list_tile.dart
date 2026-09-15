import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../theme/app_theme.dart';

class DishListTile extends StatelessWidget {
  final Dish dish;
  final VoidCallback? onTap;

  const DishListTile({super.key, required this.dish, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                dish.imagePath,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 84,
                  height: 84,
                  color: AppColors.goldLight.withValues(alpha: 0.25),
                  child: Icon(Icons.local_dining, color: AppColors.black),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dish.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (dish.isSpicy)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Text('🌶️', style: TextStyle(fontSize: 14)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dish.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${dish.price} FCFA',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
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
