import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../theme/app_theme.dart';
import '../widgets/featured_dish_card.dart';
import '../widgets/dish_list_tile.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../data/dishes_data.dart' as data;
import 'signup_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onRequireAccount;

  const HomeScreen({super.key, this.onRequireAccount});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Tous';
  String _query = '';

  List<Dish> _filterDishes(List<Dish> dishes) {
    return dishes.where((dish) {
      final matchesCategory = _selectedCategory == 'Tous' || dish.category == _selectedCategory;
      final matchesQuery = dish.name.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _handleDishTap(Dish dish) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${dish.name} ajouté à la commande')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('Belle Envie', style: AppTheme.appBarTitle),
      ),
      body: StreamBuilder<List<Dish>>(
        stream: FirestoreService.instance.getDishes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.gold));
          }

          final allDishes = snapshot.data ?? [];
          final filteredDishes = _filterDishes(allDishes);
          final featured = allDishes.isNotEmpty ? allDishes.first : null;

          return CustomScrollView(
            slivers: [
              // Bandeau noir avec mot de bienvenue, recherche et accès connexion.
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenue chez Belle Envie',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Les saveurs authentiques du Cameroun, à portée de main',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                          hintText: 'Rechercher un plat, ex: ndolé',
                          prefixIcon: Icon(Icons.search, color: AppColors.inkSoft),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Catégories défilables horizontalement.
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                    itemCount: data.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = data.categories[index];
                      final selected = category == _selectedCategory;
                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedCategory = category),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: AppColors.gold,
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: AppColors.gold.withValues(alpha: selected ? 0 : 0.25)),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bannière d'appel à l'action vers l'inscription.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                sliver: SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: AuthService.instance.isLoggedIn,
                    builder: (context, loggedIn, _) {
                      if (loggedIn) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Créez votre compte',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pour commander et réserver votre table en un clic',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: widget.onRequireAccount ??
                                      () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                                  ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              ),
                              child: const Text('S\'inscrire'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Plat vedette.
              if (featured != null)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                  sliver: SliverToBoxAdapter(
                    child: FeaturedDishCard(dish: featured, onTap: () => _handleDishTap(featured)),
                  ),
                ),

              // Titre de section.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 4),
                sliver: SliverToBoxAdapter(
                  child: Text('Le menu', style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),

              // Liste scrollable des plats.
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                sliver: SliverList.separated(
                  itemCount: filteredDishes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x1A2A211A)),
                  itemBuilder: (context, index) => DishListTile(
                    dish: filteredDishes[index],
                    onTap: () => _handleDishTap(filteredDishes[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
