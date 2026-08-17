/// Shared contract every service plugin's client implements for the
/// "Test connection" flow (spec §6). Onboarding (Phase 3+) calls this once
/// per endpoint (local/remote) before an instance is saved; each
/// `services/<name>/` plugin provides the concrete implementation.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';

/// Something that can verify it's talking to a live, authenticated
/// service instance and report back a minimal identity.
abstract interface class ConnectionTestClient {
  /// Performs a lightweight authenticated call (e.g. `/system/status` for
  /// the *arr services, `/app/version` for qBittorrent) and returns the
  /// parsed identity on success.
  Future<Result<ServiceIdentity>> testConnection();
}
