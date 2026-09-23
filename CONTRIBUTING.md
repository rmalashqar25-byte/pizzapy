# Contributing

Thanks for helping improve Py Pizza.

## Local workflow

1. Install the current stable Flutter SDK.
2. Run `flutter pub get`.
3. Create a focused branch from `main`.
4. Format and verify the project before opening a pull request:

```sh
dart format lib test
flutter analyze
flutter test
```

## Pull requests

- Keep each pull request focused on one change.
- Add or update widget tests when behavior changes.
- Do not commit generated folders, local configuration, credentials, signing files, or production customer data.
- Preserve the demo-checkout disclaimer unless a real, secured backend is added.
