import '../../models/dish.dart';

/// Liste de démonstration. Remplace les imagePath par tes propres photos
/// une fois ajoutées dans assets/images/dishes/ (voir pubspec.yaml).
const List<Dish> sampleDishes = [
  Dish(
    name: 'Ndolé aux crevettes',
    description: 'Feuilles de ndolé mijotées, arachides pilées, crevettes et viande de bœuf',
    price: 3500,
    imagePath: 'assets/images/dishes/ndole.jpg',
    category: 'Plats traditionnels',
    isSpicy: true,
  ),
  Dish(
    name: 'Eru et water fufu',
    description: 'Feuilles d\'eru, huile de palme, vidé, servi avec du water fufu',
    price: 3000,
    imagePath: 'assets/images/dishes/eru.jpg',
    category: 'Plats traditionnels',
    isSpicy: true,
  ),
  Dish(
    name: 'Poulet DG',
    description: 'Poulet sauté aux plantains mûrs, carottes et légumes',
    price: 4000,
    imagePath: 'assets/images/dishes/poulet_dg.jpg',
    category: 'Grillades',
  ),
  Dish(
    name: 'Koki',
    description: 'Gâteau de haricots vapeur à l\'huile de palme, servi avec du bobolo',
    price: 2000,
    imagePath: 'assets/images/dishes/koki.jpg',
    category: 'Plats traditionnels',
  ),
  Dish(
    name: 'Mbongo Tchobi',
    description: 'Sauce noire épicée au poisson, épices traditionnelles grillées',
    price: 3800,
    imagePath: 'assets/images/dishes/mbongo.jpg',
    category: 'Plats traditionnels',
    isSpicy: true,
  ),
  Dish(
    name: 'Jus de bissap glacé',
    description: 'Infusion d\'hibiscus, gingembre et une pointe de menthe',
    price: 1000,
    imagePath: 'assets/images/dishes/bissap.jpg',
    category: 'Boissons',
  ),
];

const List<String> categories = [
  'Tous',
  'Plats traditionnels',
  'Grillades',
  'Boissons',
  'Desserts',
];
