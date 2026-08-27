# ArrStack Companion

**ArrStack Companion** is a powerful, direct-to-service mobile client for managing your self-hosted media stack. It talks directly to your services without any intermediate servers, keeping your data private and encrypted on your device.

## Features

- **Unified Dashboard:** High-level health overview and aggregate activity across all services.
- **Library Management:** Browse, add, and monitor movies (Radarr) and TV shows (Sonarr).
- **Calendar:** Combined airing and release schedule for all your monitored media.
- **Download Control:** Full management of your qBittorrent queue with real-time stats.
- **Uptime Monitoring:** Live status and heartbeat history from Uptime Kuma.
- **Content Discovery:** Discover trending content and request media via Seerr (Overseerr/Jellyseerr).
- **Network-Aware Switching:** Automatically switches between Local LAN and Remote (Tailscale) URLs based on your WiFi SSID.

## Supported Services

- **Sonarr** (v3)
- **Radarr** (v3)
- **Bazarr**
- **qBittorrent** (v2)
- **Uptime Kuma** (Socket.io)
- **Seerr** (Overseerr/Jellyseerr)

## Getting Started

1.  **Configure Services:** Go to the **Settings** tab to add your service instances.
2.  **Dual URLs:** For each instance, you can provide a **Local URL** (e.g., `http://192.168.1.10:7878`) and a **Remote URL** (e.g., your Tailscale address).
3.  **Home WiFi:** In Settings, detect or enter your home WiFi SSID. The app will automatically use Local URLs when you're at home for maximum speed.
4.  **Security:** Your API keys and credentials are stored securely in your device's system keychain (Keystore/Keychain).

## Development

This project uses Flutter with Riverpod for state management and Freezed for data modeling.

### Build
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---
Built with ❤️ for the self-hosting community.
