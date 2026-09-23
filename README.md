# Py Pizza

A polished, offline-first Flutter restaurant demo for browsing a menu, saving favorites, building a bag, and completing a safe demonstration checkout.

> **Demo only:** Py Pizza does not submit real orders, process payments, or transmit customer information.

## Highlights

- Three focused experiences: Home, Menu, and Bag
- Search and category filters
- Favorite menu items
- Product detail sheets with quantity selection
- Live bag quantities, subtotal, delivery fee, and total
- Responsive phone/web layout
- Bundled food photography for offline use
- Automated Flutter analysis and widget tests in GitHub Actions

## Preview flow

1. Discover featured products on Home.
2. Search or filter the complete Menu.
3. Open an item and choose a quantity.
4. Update quantities in the Bag.
5. Complete the clearly labeled demo checkout.

## Getting started

### Requirements

- Flutter 3.38.7 or compatible stable release
- Dart 3.10 or newer
- Android Studio, Xcode on macOS, or a supported browser

### Run

```sh
flutter pub get
flutter run
```

For Chrome:

```sh
flutter run -d chrome
```

## Quality checks

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --release
```

These checks also run automatically for pushes and pull requests through [Flutter CI](.github/workflows/flutter-ci.yml).

## Project structure

```text
assets/images/       Local menu photography
lib/main.dart        Application, navigation, menu, and bag experience
test/                End-to-end widget behavior tests
tooling/             Local asset-generation utilities
web/                 Progressive web app shell and metadata
```

The application intentionally keeps its catalog local because it is a small demonstration. A production ordering system should add an authenticated backend, server-owned pricing, inventory checks, payment-provider tokenization, observability, and secure order confirmation.

## Contributing and security

Read [CONTRIBUTING.md](CONTRIBUTING.md) before proposing changes. Please report vulnerabilities according to [SECURITY.md](SECURITY.md).
