# Savoria - Gourmet Dining

Flutter gourmet dining app with Firebase email/password authentication and an asset-backed JSON menu.

## Run

```sh
flutter pub get
flutter run
```

Keep your existing `lib/firebase_options.dart` and platform Firebase configuration. Authentication still uses Firebase; browsing the menu no longer reads or seeds Firestore.

## Content

Edit `assets/data/menu.json` to change the dishes shown in Explore, search, category filters, favorites, details, and the cart. The `recipes` array requires unique, stable `id` values, strings for `title`, `category`, `restaurant` and `imageUrl`, nonnegative numbers for `price`, `cookTimeMinutes`, `servings` and `calories`, and string arrays for `ingredients` and `instructions`. Prices currently display in USD. The included catalog is editable illustrative content, not a live restaurant inventory. Image URLs require internet; unavailable images have a local icon fallback.

`assets/data/account.json` contains empty `addresses`, `orders`, and `paymentMethods` arrays so the UI does not present fictional personal records. To display non-sensitive public demonstration records, each entry takes `title` and `description` strings. Bundled assets are shared by every installation: do not put customer information, card details, or secrets in this file. Real customer records require a user-scoped backend.

The old sample-data upload action and Firestore menu subscription have been removed. Existing remote documents are not deleted. Cart and favorite storage use new keys so old sample items do not reappear. New selections persist on this device.

## UI and feature scope

The responsive "Savoria" interface uses deep warm charcoal, rich amber-gold accents, elevated dark cards, clean typography, and a modern navigation bar. The system covers login, registration, menu, dish details, bag, favorites, account, and account subpages. Email authentication and password reset use Firebase. Checkout remains visibly unavailable until an order/payment backend is implemented. Existing notification and security settings remain UI-only controls.

## Verify

```sh
flutter analyze
flutter test
flutter build web
```
