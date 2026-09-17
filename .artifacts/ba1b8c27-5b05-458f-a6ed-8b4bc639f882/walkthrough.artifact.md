# Walkthrough : Expérience Utilisateur Repensée

L'application **Belle Envie** dispose désormais d'un flux d'entrée professionnel, fluide et sécurisé.

## Améliorations majeures

### 1. Écran de Bienvenue (`WelcomeScreen`)
L'application ne vous force plus à voir un tableau de bord par défaut. Elle vous accueille avec trois choix clairs :
- **Se connecter** : Pour les clients et le personnel existants.
- **Créer un compte** : Pour les nouveaux gourmets.
- **Continuer en tant que visiteur** : Pour consulter le menu sans engagement.

### 2. Mode Visiteur Intelligent
Si vous choisissez de visiter l'app :
- Vous pouvez naviguer librement sur le **Menu**.
- Mais dès que vous essayez d'accéder aux **Réservations**, à vos **Commandes** ou à votre **Profil**, l'application vous présente gentiment l'écran `AccountRequiredView` avec des boutons directs vers la connexion.

### 3. Redirection Automatique par Rôle
Le système "hardcoded" a été supprimé. Désormais, c'est la **vraie base de données** qui décide :
- Connectez-vous avec vos identifiants réels.
- `AuthWrapper` détecte votre rôle en temps réel.
- Si vous êtes **Admin**, vous arrivez directement sur votre Dashboard.
- Si vous êtes **Cuisinier**, vous arrivez en cuisine.
- Si vous êtes **Client**, vous arrivez au restaurant.

### 4. Navigation et Déconnexion
- Chaque Dashboard possède son bouton de déconnexion.
- La déconnexion vous ramène instantanément au `WelcomeScreen` et réinitialise tout le système.

## Comment tester ?
1.  **Lancer l'app** : Admirez le nouveau `WelcomeScreen`.
2.  **Cliquer sur Visiteur** : Vérifiez que vous pouvez voir les plats mais pas réserver.
3.  **Se connecter** : Utilisez vos identifiants admin réels. Vérifiez que vous arrivez sur le Dashboard Admin.
4.  **Déconnexion** : Vérifiez que vous revenez bien à l'accueil.
