/// `ArrService` interface(s): connection test, list, add, search, etc. All
/// service plugins under `services/<name>/` implement these contracts so
/// features stay service-agnostic (spec §5). Grows as each service module
/// lands (Phase 4+); Phase 2 seeds the connection-test contract only.
library;

export 'package:arrstack/services/contracts/connection_test_client.dart';
