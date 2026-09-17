# Plan de Refonte : Authentification, UX et Mode Visiteur

L'objectif est de créer un flux d'entrée professionnel qui respecte les rôles et offre une option "Visiteur" tout en protégeant les actions sensibles.

## État des lieux (Logique Client actuelle)

> [!NOTE]
> Bonne nouvelle : **la logique de blocage existe déjà partiellement** dans votre dashboard client. Actuellement, les écrans suivants affichent déjà un message "Connexion requise" si l'utilisateur n'est pas authentifié :
> - **Profil** (`ProfileScreen`)
> - **Réservations** (`ReservationScreen`)
> - **Commandes** (`OrdersScreen`)
>
> Nous allons simplement réutiliser et affiner ce système.

## Proposed Changes

### 1. Service d'Authentification (`AuthService`)
*   **[MODIFY]** : Suppression totale de l'administrateur hardcodé.
*   **[NEW]** : Ajout d'un état `isGuestMode` (ValueNotifier) pour savoir si l'utilisateur a choisi de visiter sans compte.

### 2. Écran de Bienvenue (`WelcomeScreen`)
*   **[NEW]** : Un magnifique écran d'accueil avec :
    *   Bouton **Se connecter** -> vers `LoginScreen`.
    *   Bouton **S'inscrire** -> vers `SignupScreen`.
    *   Bouton **Continuer en tant que visiteur** -> active le `isGuestMode` et ouvre le dashboard client.

### 3. Wrapper d'Authentification (`AuthWrapper`)
*   **[MODIFY]** : Nouvelle logique de décision :
    1.  `isLoading` ? -> Cercle de chargement.
    2.  `isLoggedIn` ? -> Redirection métier (Admin, Cook, Cashier, Client).
    3.  `isGuestMode` ? -> Affiche `MainShell` (le menu).
    4.  Sinon ? -> Affiche `WelcomeScreen`.

### 4. Amélioration de l'UX "Visiteur"
*   **[MODIFY]** : Dans les écrans bloqués (Profil, Réservations), nous ajouterons un bouton sur le message "Connexion requise" pour renvoyer l'utilisateur vers la page de connexion sans qu'il soit perdu.

## Verification Plan

### Manual Verification
1.  **Premier lancement** : L'app s'ouvre sur le `WelcomeScreen`.
2.  **Test Visiteur** : Cliquer sur "Visiteur", vérifier qu'on voit le menu mais que "Réserver" demande une connexion.
3.  **Test Connexion** : Se connecter en Admin et vérifier qu'on arrive **directement** sur le Dashboard Admin sans voir le client.
4.  **Test Déconnexion** : Revenir instantanément au `WelcomeScreen`.
