import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/requests/widgets/request_card.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

SeerrRequest pendingRequest({int id = 1}) => SeerrRequest(
  id: id,
  status: SeerrRequestStatus.pending,
  media: const SeerrRequestMedia(id: 1, tmdbId: 100, mediaType: 'movie'),
  requestedBy: const SeerrRequestUser(displayName: 'harivin'),
);

class _FakeRepository extends SeerrRepository {
  _FakeRepository({this.approveError, this.declineError})
    : super(SeerrClient(Dio()));

  final AppError? approveError;
  final AppError? declineError;
  int approveCalls = 0;
  int declineCalls = 0;

  @override
  Future<Result<SeerrRequest>> approveRequest(int requestId) async {
    approveCalls++;
    final error = approveError;
    if (error != null) return Err(error);
    return Ok(pendingRequest(id: requestId));
  }

  @override
  Future<Result<SeerrRequest>> declineRequest(int requestId) async {
    declineCalls++;
    final error = declineError;
    if (error != null) return Err(error);
    return Ok(pendingRequest(id: requestId));
  }
}

Widget host(SeerrRepository repo, {VoidCallback? onDecided}) {
  return ProviderScope(
    overrides: [
      seerrRepositoryProvider(instanceId).overrideWith((ref) async => repo),
      seerrDetailProvider(
        instanceId: instanceId,
        id: 100,
        mediaType: 'movie',
      ).overrideWith(
        (ref) async => const Ok(SeerrResult(id: 100, title: 'Mickey 17')),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: RequestCard(
          instanceId: instanceId,
          request: pendingRequest(),
          onDecided: onDecided ?? () {},
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the title, a Pending tag, and Approve/Deny buttons', (
    tester,
  ) async {
    await tester.pumpWidget(host(_FakeRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Mickey 17'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
  });

  testWidgets(
    'tapping Approve calls the repository, disables both buttons, and notifies onDecided',
    (tester) async {
      final repo = _FakeRepository();
      var decided = false;
      await tester.pumpWidget(host(repo, onDecided: () => decided = true));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Approve'));
      await tester.pump();

      expect(repo.approveCalls, 1);
      final denyButton = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Deny'),
      );
      expect(denyButton.onPressed, isNull);

      await tester.pumpAndSettle();
      expect(decided, isTrue);
    },
  );

  testWidgets('a failed decline shows an error and re-enables both buttons', (
    tester,
  ) async {
    final repo = _FakeRepository(
      declineError: const UnknownError(userMessage: 'boom'),
    );
    await tester.pumpWidget(host(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Deny'));
    await tester.pumpAndSettle();

    expect(find.text('boom'), findsOneWidget);
    final approveButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Approve'),
    );
    expect(approveButton.onPressed, isNotNull);
  });

  testWidgets('a failed approve shows an error and re-enables both buttons', (
    tester,
  ) async {
    final repo = _FakeRepository(
      approveError: const UnknownError(userMessage: 'kaboom'),
    );
    await tester.pumpWidget(host(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Approve'));
    await tester.pumpAndSettle();

    expect(find.text('kaboom'), findsOneWidget);
    final denyButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Deny'),
    );
    expect(denyButton.onPressed, isNotNull);
  });
}
