# ArrStack Companion

**ArrStack Companion** is a direct-to-service mobile client for managing your self-hosted media stack. It talks directly to your services with no intermediate servers, keeping your credentials private and encrypted on-device.

## Features

- **Unified Dashboard:** High-level health overview and aggregate activity across every configured service; each card links through to its detail screen.
- **Library Management:** Browse, add, and monitor movies (Radarr) and TV shows (Sonarr), down to per-episode detail.
- **Calendar:** Combined airing and release schedule for all your monitored media.
- **Download Control:** Manage your qBittorrent queue with real-time transfer stats.
- **Indexer Health:** Review Prowlarr indexers and their query/grab statistics.
- **Subtitles:** Track and search Bazarr's wanted-subtitle list for movies and episodes.
- **Uptime Monitoring:** Live status and heartbeat history from Uptime Kuma.
- **Content Discovery:** Browse trending content and request media via Seerr (Overseerr/Jellyseerr).
- **Network-Aware Switching:** Automatically picks each instance's Local LAN or Remote (Tailscale) URL based on the connected WiFi SSID, falling back to the remote URL when the network can't be determined.

## Supported Services

- **Sonarr** (API v3)
- **Radarr** (API v3)
- **Prowlarr** (API v1)
- **Bazarr** (REST API)
- **qBittorrent** (WebUI API v2)
- **Uptime Kuma** (Socket.IO)
- **Seerr** — Overseerr / Jellyseerr (API v1)

## Install

Builds run automatically on every push to `main`:

- **Latest APK:** the [`nightly`](https://github.com/rhp4515/arrstack-app/releases/tag/nightly) pre-release always carries the most recent build. Download the `.apk` and sideload it — Android will prompt you to allow installs from your browser or file manager the first time.
- Pushing a `v*` tag produces a matching versioned release.

APKs are debug-signed for personal sideloading; they are not distributed through an app store.

## Getting Started

1.  **Add Services:** Open the **Settings** tab and add your service instances.
2.  **Dual URLs:** For each instance you can provide a **Local URL** (e.g. `http://192.168.1.10:7878`) and a **Remote URL** (e.g. your Tailscale address).
3.  **Home WiFi:** In Settings, detect or enter your home WiFi SSID. The app uses Local URLs when you're on that network and Remote URLs otherwise.
4.  **Security:** API keys and credentials are stored in your device's system keychain (Keystore on Android, Keychain on iOS).
5.  **Bazarr & Prowlarr:** open these from their cards on the Dashboard.

## Development

This project uses Flutter with Riverpod for state management and Freezed for data modeling. Generated sources (`*.g.dart`, `*.freezed.dart`) are committed to the repo.

### Build
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### CI

- `ci.yml` runs `flutter analyze` and `flutter test` on every push and pull request.
- `release-apk.yml` builds and publishes the APK described under [Install](#install).

---
Built with ❤️ for the self-hosting community.
