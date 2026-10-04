import 'package:arrstack/app/router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('router has the 3-branch shell plus the standalone logs page', () {
    final shellRoute = appRouter.configuration.routes.first;
    expect(appRouter.configuration.routes.length, 2);
    expect(shellRoute.runtimeType.toString(), 'StatefulShellRoute');
  });

  test('initial location is /home', () {
    // `routerDelegate.currentConfiguration` is only populated once a
    // `Router` widget attaches and drives route matching, so a plain
    // (non-widget-tree) unit test reads the seeded initial location off
    // the route information provider instead.
    expect(appRouter.routeInformationProvider.value.uri.path, '/home');
  });
}
