# Structure de la base de données Firestore

Pour que votre application fonctionne avec les données réelles, vous devez organiser votre base de données Firestore comme suit.

## 1. Collection `dishes` (Les Plats)

C'est ici que vous stockez tous les articles de votre menu. Chaque document représente un plat.

### Format d'un document :
- **ID du document** : Laisser Firebase le générer automatiquement.
- **Champs** :
  - `name` (string) : Nom du plat (ex: "Ndolé aux crevettes")
  - `description` (string) : Description détaillée
  - `price` (number) : Prix en FCFA (ex: 3500)
  - `category` (string) : La catégorie exacte (ex: "Plats traditionnels")
  - `imagePath` (string) : URL de l'image.
    > [!TIP]
    > Pour commencer, vous pouvez utiliser des liens vers des images en ligne ou télécharger vos photos dans **Firebase Storage** et copier le "Lien de téléchargement".
  - `isSpicy` (boolean) : `true` ou `false`

## 2. Collection `categories` (Les Catégories)

Pour gérer les onglets de filtrage dynamiquement.

### Format :
- **ID du document** : Mettre le nom de la catégorie directement comme ID (ex: "Grillades").
- **Champs** : Vous n'avez pas besoin de champs spécifiques pour l'instant, l'application utilise l'ID du document comme nom de catégorie.

---

## 3. Sécurité (Règles Firestore)

Pour permettre à l'application de lire les données, allez dans l'onglet **Rules** de Firestore et assurez-vous d'avoir au moins ceci :

```javascript
service cloud.firestore {
  match /databases/{database}/documents {
    // Tout le monde peut lire le menu
    match /dishes/{dish} {
      allow read: if true;
      allow write: if false; // Seul vous devriez modifier via la console
    }
    match /categories/{category} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

## Astuce : Automatisation
Si vous le souhaitez, je peux créer un petit script temporaire dans votre application qui enverra automatiquement vos données locales actuelles (`sampleDishes`) vers Firebase pour vous faire gagner du temps. **Voulez-vous que je fasse cela ?**
