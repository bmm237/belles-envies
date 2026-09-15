# Plan d'intégration Firebase pour Belle Envie

L'objectif est de remplacer le système de données simulées par un véritable backend utilisant **Firebase**. Cela permettra de gérer les utilisateurs (inscription/connexion) et de stocker le menu en ligne.

## User Review Required

> [!IMPORTANT]
> **Configuration Firebase** : Pour que l'application puisse se connecter, vous devrez créer un projet sur la console Firebase et ajouter les fichiers de configuration (`google-services.json` pour Android). Je peux vous guider pour cette étape via le terminal ou manuellement.

> [!WARNING]
> **Changement de structure** : La liste des plats ne sera plus "fixe" dans le code mais viendra du cloud. Cela signifie qu'il faudra une connexion internet pour voir le menu au premier chargement.

## Proposed Changes

### Configuration et Dépendances

#### [MODIFY] [pubspec.yaml](file:///C:/Users/MELI/StudioProjects/belle_envie/pubspec.yaml)
*   Ajout de `firebase_core`, `firebase_auth` (pour les utilisateurs) et `cloud_firestore` (pour le menu).

### Services Backend

#### [MODIFY] [auth_service.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/services/auth_service.dart)
*   Remplacement de la logique de simulation par les appels réels à `FirebaseAuth.instance`.
*   Gestion du flux de connexion (Email/Mot de passe).

#### [NEW] [firestore_service.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/services/firestore_service.dart)
*   Création d'un service pour récupérer les plats depuis la base de données Firestore.
*   Méthodes pour écouter les changements du menu en temps réel.

### Modèles de Données

#### [MODIFY] [dish.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/models/dish.dart)
*   Ajout d'une méthode `fromFirestore` pour transformer les données reçues de Firebase en objets Dart utilisables par l'interface.

### Interface Utilisateur (UI)

#### [MODIFY] [main.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/main.dart)
*   Initialisation de Firebase au démarrage de l'application.

#### [MODIFY] [home_screen.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/home_screen.dart)
*   Utilisation du nouveau `FirestoreService` pour afficher les vrais plats.

## Verification Plan

### Automated Tests
*   `flutter pub get` pour vérifier que les dépendances sont correctes.
*   Lancement de l'application pour vérifier l'initialisation de Firebase.

### Manual Verification
1.  Tenter de s'inscrire via l'écran dédié et vérifier la création du compte dans la console Firebase.
2.  Ajouter manuellement un plat dans Firestore et vérifier qu'il apparaît instantanément dans l'application.
