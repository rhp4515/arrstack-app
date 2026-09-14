import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/onboarding/add_instance_page.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/fakes.dart';

void main() {
  testWidgets(
    'shows the error card first when editing with a failed local test',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instanceFormProvider.overrideWith(_FakeFailingInstanceForm.new),
            // load() fires from initState() even though the fake notifier
            // already seeds the failing state; without this override it
            // reaches the real SharedPreferencesAsync platform channel, which
            // isn't registered in a plain widget test.
            configStoreProvider.overrideWithValue(FakeConfigStore()),
          ],
          child: const MaterialApp(
            home: AddInstancePage(instanceId: 'bazarr-1'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Local URL refused the connection'), findsOneWidget);
      expect(find.text('Use Remote for now'), findsOneWidget);
      expect(find.text('Test again'), findsOneWidget);
    },
  );

  testWidgets(
    'renders the plain add form with no error card when adding fresh',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: AddInstancePage())),
      );
      await tester.pump();

      expect(find.text('Local URL refused the connection'), findsNothing);
      expect(find.text('Add service'), findsOneWidget);
    },
  );

  testWidgets(
    'Use Remote for now sets a session override to forceRemote and pops',
    (tester) async {
      final overrideNotifier = _RecordingEndpointSessionOverride();
      // initialLocation is '/' (not '/edit' directly) and '/edit' is reached
      // via push below, so the Navigator actually has something to pop —
      // starting at '/edit' with nothing pushed before it leaves GoRouter
      // with a single-page stack and `context.pop()` throws "nothing to pop".
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SizedBox()),
          GoRoute(
            path: '/edit',
            builder: (context, state) =>
                const AddInstancePage(instanceId: 'bazarr-1'),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instanceFormProvider.overrideWith(_FakeFailingInstanceForm.new),
            endpointSessionOverrideProvider.overrideWith(
              () => overrideNotifier,
            ),
            configStoreProvider.overrideWithValue(FakeConfigStore()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump();
      router.push('/edit');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use Remote for now'));
      await tester.pumpAndSettle();

      expect(overrideNotifier.calls, [('bazarr-1', EndpointMode.forceRemote)]);
    },
  );
}

class _FakeFailingInstanceForm extends InstanceForm {
  @override
  InstanceFormState build() => const InstanceFormState(
    id: 'bazarr-1',
    name: 'Bazarr',
    type: ServiceType.bazarr,
    localUrl: 'http://192.168.1.10:6767',
    localTestResult: Err(
      NetworkError(cause: 'SocketException: Connection refused'),
    ),
  );
}

/// Records every session-override call instead of just applying it, so the
/// "Use Remote for now" test can assert on instanceId + mode without
/// depending on resolvedEndpointProvider's full resolution chain.
class _RecordingEndpointSessionOverride extends EndpointSessionOverride {
  final calls = <(String, EndpointMode?)>[];

  @override
  Map<String, EndpointMode?> build() => const {};

  @override
  void update(String instanceId, EndpointMode? mode) {
    calls.add((instanceId, mode));
    super.update(instanceId, mode);
  }
}
