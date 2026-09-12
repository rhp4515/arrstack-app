/// Providers backing the Activity page: which lens is active, and the
/// Sonarr/Bazarr aggregations the Wanted lens needs (Phase 4 design
/// §Provider plan).
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_providers.g.dart';

/// The three switchable lenses on the Activity page (spec screens 2h/2i/2j).
enum ActivityLens { transfers, calendar, wanted }

/// Which [ActivityLens] the Activity page shows. `go_router`'s
/// `StatefulShellRoute` (or, after this phase, a single non-shell route)
/// keeps the page's own widget state around across visits, so this
/// provider — not local widget state — lets Home's tile taps and deep
/// links force the right lens every time. Mirrors `ActiveLibraryTab`
/// (`lib/features/library/library_providers.dart`).
@riverpod
class ActiveActivityLens extends _$ActiveActivityLens {
  @override
  ActivityLens build() => ActivityLens.transfers;

  void select(ActivityLens lens) => state = lens;
}
