# Intégration Firebase terminée

L'application **Belle Envie** est désormais connectée à Firebase pour l'authentification et le stockage des données.

## Changements effectués

### Core & Configuration
- **[pubspec.yaml](file:///C:/Users/MELI/StudioProjects/belle_envie/pubspec.yaml)** : Ajout des packages `firebase_core`, `firebase_auth`, et `cloud_firestore`.
- **[main.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/main.dart)** : Initialisation asynchrone de Firebase au lancement.

### Services & Modèles
- **[AuthService](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/services/auth_service.dart)** : Passage à `FirebaseAuth`. L'état de connexion est désormais synchronisé automatiquement.
- **[FirestoreService](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/services/firestore_service.dart)** : **[NOUVEAU]** Service dédié pour récupérer le menu en temps réel depuis Firestore.
- **[Dish](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/models/dish.dart)** : Ajout de méthodes de conversion Firestore (`fromFirestore` / `toFirestore`).

### Interface Utilisateur (UI)
- **[HomeScreen](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/home_screen.dart)** : Utilise maintenant un `StreamBuilder` pour afficher les plats directement depuis le cloud.
- **[SignupScreen](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/signup_screen.dart)** & **[LoginScreen](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/login_screen.dart)** : Branchés sur les fonctions réelles de création de compte et de connexion.

> [!IMPORTANT]
> **Rappel Final** : N'oubliez pas d'ajouter votre fichier `google-services.json` dans le dossier `android/app/` pour que la connexion soit effective sur un appareil Android.

## Prochaines étapes
1.  **Peuplement de la base** : Vous pouvez maintenant ajouter vos plats dans une collection nommée `dishes` dans la console Firestore.
2.  **Images** : Pensez à utiliser des URLs d'images (Firebase Storage par exemple) pour le champ `imagePath` de vos documents Firestore.
