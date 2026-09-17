# Analyse Logique du Projet Belle Envie

Voici une vue d'ensemble de l'architecture et du fonctionnement de votre application.

## 1. Architecture Globale
Le projet suit une structure **Service-Oriented Architecture (SOA)** simplifiée pour Flutter :
- **Models** : Définissent la structure des données (Plat, Utilisateur, Stock, Réservation).
- **Services** : Gèrent la communication avec le monde extérieur (Firebase Auth et Firestore).
- **Screens** : L'interface utilisateur découpée par métier (Client, Admin, Cuisine, Caisse).
- **Widgets** : Composants réutilisables (boutons, cartes, listes).

---

## 2. La Logique métier (Le "Cerveau")

### Authentification et Rôles (`AuthService`)
C'est le point le plus important. L'application ne se contente pas de savoir *qui* vous êtes, elle sait *ce que vous faites* dans le restaurant.
- **Flux** : Connexion -> Récupération du rôle dans Firestore -> Mise à jour de l'interface.
- **Rôles gérés** : `admin` (superviseur), `cook` (menu/cuisine), `cashier` (vente), `client` (visiteur).

### Flux de données (`FirestoreService`)
Toutes les données sont **"vivantes"** (Temps Réel) :
- Si un client réserve une table sur son téléphone, l'Admin voit la notification apparaître sur son Dashboard sans rafraîchir la page.
- Si le stock de riz baisse, l'Admin voit une alerte rouge instantanément.

---

## 3. Structure des Écrans (La Navigation)

### L'Entrée (`AuthWrapper`)
C'est le "garde-barrière". Il décide quel univers afficher :
- **Univers Client (`MainShell`)** : Une application élégante en noir et or pour commander et réserver.
- **Univers Admin (`AdminDashboard`)** : Un tableau de bord avec des statistiques et des outils de gestion humaine et matérielle.
- **Univers Personnel (`Cook/Cashier Dashboards`)** : Des outils simplifiés pour la productivité.

---

## 4. État Actuel du Projet
- **Backend** : Firebase est entièrement configuré.
- **Base de données** : Les structures pour les utilisateurs, les stocks et les réservations sont prêtes.
- **Navigation** : Actuellement, nous avons forcé le démarrage sur l'Admin pour faciliter votre travail, mais le système automatique est prêt.

---

## 5. Ce qu'il reste à "Muscler"
1.  **Prise de commande** : Le tunnel d'achat complet pour le client.
2.  **Cuisine active** : Un système pour que le cuisinier coche les plats terminés.
3.  **Images dynamiques** : Remplacer les images locales par des liens vers Firebase Storage pour que le menu soit modifiable sans mise à jour de l'app.
