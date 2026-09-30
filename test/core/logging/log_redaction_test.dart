// The diagnostic log is written to be shared, so nothing identifying the
// user's server or credentials may survive redaction.

import 'package:arrstack/core/logging/log_redaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('replaces URL hosts but keeps the scheme', () {
    expect(
      redactDiagnosticMessage('GET http://192.168.1.10:7878/api/v3/queue'),
      'GET http://<host>/api/v3/queue',
    );
    expect(
      redactDiagnosticMessage('https://nas.tail1234.ts.net:8989/x'),
      'https://<host>/x',
    );
  });

  test('replaces bare IPv4 addresses, Tailscale names, and IPv6', () {
    expect(
      redactDiagnosticMessage(
        'SocketException: Connection refused, address = 100.101.5.6, port = 7878',
      ),
      'SocketException: Connection refused, address = <host>, port = 7878',
    );
    expect(
      redactDiagnosticMessage("Couldn't look up nas.tail1234.ts.net."),
      "Couldn't look up <host>.",
    );
    expect(redactDiagnosticMessage('at [fd7a:115c::1]:80'), 'at <host>');
  });

  test('masks labelled secrets and bare 32-hex API keys', () {
    const key = '0123456789abcdef0123456789ABCDEF';
    final out = redactDiagnosticMessage(
      'apikey=$key password: hunter2 token="abc def" raw $key',
    );
    expect(out, isNot(contains(key)));
    expect(out, isNot(contains('hunter2')));
    expect(out, isNot(contains('abc def')));
    expect(out, contains('apikey=<redacted>'));
  });

  test('leaves ordinary text alone', () {
    const message = 'Radarr GET api/v3/movie failed | AuthError (HTTP 401)';
    expect(redactDiagnosticMessage(message), message);
  });
}
