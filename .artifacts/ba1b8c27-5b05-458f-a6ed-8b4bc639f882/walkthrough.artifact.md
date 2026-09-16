# Walkthrough : Dashboards Multi-Rôles et Gestion Admin

J'ai implémenté les bases des interfaces dédiées pour chaque métier du restaurant, ainsi que la logique de gestion des rôles.

## Ce qui a été fait

### 1. Gestion des Utilisateurs et Rôles
- **Modèle `AppUser`** : Chaque utilisateur a désormais un rôle (`admin`, `cook`, `cashier`, `client`).
- **`AuthService`** : Lors de la connexion, l'application récupère automatiquement les données de l'utilisateur depuis la collection Firestore `users`.
- **`ProfileScreen`** : Affiche un badge indiquant le rôle et propose un bouton "Tableau de bord" uniquement pour le personnel.

### 2. Dashboard Admin (Gestionnaire)
- **Interface** : Un hub central pour superviser les employés, les stocks et les réservations.
- **Gestion des Employés** : L'Admin peut changer le rôle de n'importe quel utilisateur (ex: transformer un client en cuisinier).
- **Gestion des Stocks** : Liste des ingrédients avec alertes visuelles (icône rouge) quand le stock est bas. Possibilité de mettre à jour les quantités.
- **Réservations** : Vue globale de toutes les réservations avec possibilité de confirmer ou annuler.

### 3. Dashboards Cuisinier et Caissier
- **Cuisinier** : Interface simplifiée pour gérer le menu et les commandes.
- **Caissier** : Interface optimisée pour la caisse et le suivi des réservations quotidiennes.

### 4. Réservations Clients
- La page **Réserver une table** est maintenant fonctionnelle : elle enregistre la demande directement dans Firestore, ce qui permet à l'Admin de la voir instantanément.

---

## Instructions pour tester

1.  **Créer un compte** : Inscrivez-vous normalement dans l'application.
2.  **Passer Admin** : Allez dans la console Firebase, collection `users`, cherchez votre document et changez le champ `role` de `client` à `admin`.
3.  **Voir le changement** : Revenez sur l'écran **Profil** de l'application. Vous verrez apparaître le bouton "Tableau de bord admin".
4.  **Gérer le personnel** : Depuis le dashboard, vous pourrez alors promouvoir d'autres comptes au rang de Cuisinier ou Caissier.

> [!TIP]
> Pour le stock, assurez-vous de créer une collection `inventory` dans Firestore avec des documents contenant `name`, `quantity` (number), `unit` (string) et `minThreshold` (number).
