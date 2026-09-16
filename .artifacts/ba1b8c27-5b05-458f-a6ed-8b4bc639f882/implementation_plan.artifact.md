# Plan d'implémentation : Dashboard Admin & Rôles

L'objectif est de créer un espace de gestion complet pour l'administrateur, axé sur les employés, les stocks et les réservations, tout en préparant le terrain pour les autres rôles (Cuisinier, Caissier).

## User Review Required

> [!IMPORTANT]
> **Définition des Rôles** : Nous allons mettre en place 4 rôles :
> 1.  **Admin** : Gère les employés, les stocks et voit toutes les réservations.
> 2.  **Cuisinier** : Gère le menu (plats) et voit les commandes en cuisine.
> 3.  **Caissier** : Gère les paiements et les commandes client.
> 4.  **Client** : Utilisateur standard.

> [!CAUTION]
> **Sécurité des Rôles** : La modification des rôles d'employés doit être strictement réservée à l'Admin dans Firestore via des règles de sécurité.

## Proposed Changes

### 1. Modèles de Données & Services
*   **[NEW] [employee.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/models/employee.dart)** : Modèle pour les membres du personnel.
*   **[NEW] [inventory_item.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/models/inventory_item.dart)** : Modèle pour les stocks (nom, quantité, unité).
*   **[NEW] [reservation.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/models/reservation.dart)** : Modèle pour les réservations.
*   **[MODIFY] [firestore_service.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/services/firestore_service.dart)** : Ajouter les méthodes CRUD pour `employees`, `inventory` et `reservations`.

### 2. Interfaces Dédiées (Dashboards distincts)
*   **[NEW] [admin_dashboard.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/admin/admin_dashboard.dart)** : Hub central Admin (Employés, Stocks, Réservations, Stats financières).
*   **[NEW] [cook_dashboard.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/cook/cook_dashboard.dart)** : Hub Cuisinier (Gestion du menu, Commandes en cours, Alertes stocks bas).
*   **[NEW] [cashier_dashboard.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/cashier/cashier_dashboard.dart)** : Hub Caissier (Prise de commande, Paiements, Liste des réservations du jour).
*   **[NEW] [manage_employees_screen.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/admin/manage_employees_screen.dart)** : Réservé à l'Admin.
*   **[NEW] [manage_inventory_screen.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/admin/manage_inventory_screen.dart)** : Réservé à l'Admin (avec consultation possible par le Cuisinier).

### 3. Logique de Navigation
*   **[MODIFY] [profile_screen.dart](file:///C:/Users/MELI/StudioProjects/belle_envie/lib/screens/profile_screen.dart)** : Ajouter une section "Administration" visible uniquement par l'Admin.

## Verification Plan

### Manual Verification
1.  **Rôles** : Vérifier qu'un utilisateur créé n'a pas accès au dashboard par défaut.
2.  **Employés** : Changer le rôle d'un utilisateur en "Cuisinier" et vérifier que le changement est effectif en base.
3.  **Stocks** : Ajouter un article (ex: "Riz - 50kg") et vérifier qu'il apparaît dans la liste.
4.  **Réservations** : Faire une réservation en tant que client et vérifier qu'elle apparaît instantanément dans le dashboard Admin.
