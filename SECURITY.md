# Security policy

ArrStack Companion stores API keys and credentials for your self-hosted
services on your device (Android Keystore / iOS Keychain) and talks to those
services directly. There is no ArrStack server.

## Reporting a vulnerability

Please report security issues **privately**, not in a public issue:

1. Go to the repository's **Security** tab and choose **Report a vulnerability**
   (GitHub private vulnerability reporting), or
2. open an issue that says only that you have a security report, without
   details, and a maintainer will arrange a private channel.

Include which build you installed (the release name or nightly build date), your platform, and steps to
reproduce. You can expect an acknowledgement within a few days. This is a
personal project maintained in spare time, so fixes are best-effort.

## Scope

In scope: how the app stores or transmits credentials, backup export/import,
app lock, and handling of data returned by your services.

Out of scope: vulnerabilities in Sonarr, Radarr, Prowlarr, Bazarr, Seerr,
qBittorrent, Uptime Kuma, Tailscale or your own network setup — please report
those to their projects.
