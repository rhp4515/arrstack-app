# Contributing

Thanks for helping out. ArrStack Companion is a Flutter app (Riverpod +
Freezed) for managing a self-hosted *arr stack.

## Getting set up

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Generated sources (`*.g.dart`, `*.freezed.dart`) are committed, so re-run
`build_runner` and commit its output when you change a model or provider.

## Before you open a pull request

```bash
dart format .
flutter analyze
flutter test
```

CI runs `flutter analyze` and `flutter test` on every pull request; both must
pass.

## Guidelines

- Keep a change focused; one feature or fix per pull request.
- Add or update tests for behavior you change. Widget and unit tests live under
  `test/`, mirroring `lib/`.
- Match the surrounding code: library doc comment at the top of a file,
  `Result`/`Ok`/`Err` for service calls, design tokens from
  `lib/app/theme/design_tokens.dart` instead of raw colors and sizes.
- Never commit API keys, hostnames or IPs from your own setup, or screenshots
  that show them.
- Changes to how credentials are stored or transmitted: see
  [SECURITY.md](SECURITY.md) first.

## Reporting bugs

Open an issue with the build you installed (release name or nightly date), your platform, which service and version
you are using, and — if you can — the log from **Settings → Advanced →
Diagnostic logs** (hostnames are redacted, but please check before posting).

By contributing you agree that your contribution is licensed under the
project's [MIT License](LICENSE).
