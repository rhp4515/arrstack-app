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

  group('credentials carried in HTTP headers', () {
    // qBittorrent authenticates with exactly these two shapes — a bearer API
    // key, or an SID session cookie — and neither carries a `key=` label
    // for the patterns above to find.

    test('masks an Authorization bearer token but keeps the scheme', () {
      for (final token in [
        'qbt_8f3kd92jdk3lsd0',
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIn0.c2lnbmF0dXJl',
      ]) {
        final out = redactDiagnosticMessage('Authorization: Bearer $token');
        expect(out, isNot(contains(token)));
        expect(out, 'Authorization: Bearer <redacted>');
      }
    });

    test('masks Basic credentials, which are base64 of user:password', () {
      final out = redactDiagnosticMessage(
        'authorization: Basic dXNlcjpodW50ZXIy',
      );
      expect(out, isNot(contains('dXNlcjpodW50ZXIy')));
      expect(out, 'authorization: Basic <redacted>');
    });

    test('masks Proxy-Authorization too', () {
      expect(
        redactDiagnosticMessage('Proxy-Authorization: Bearer abcdefgh1234'),
        'Proxy-Authorization: Bearer <redacted>',
      );
    });

    test('masks every value in a Cookie header', () {
      final out = redactDiagnosticMessage('Cookie: SID=a1b2c3d4e5; lang=en');
      expect(out, isNot(contains('a1b2c3d4e5')));
      expect(out, 'Cookie: <redacted>');
    });

    test('masks a Set-Cookie session value, attributes and all', () {
      final out = redactDiagnosticMessage(
        'set-cookie: SID=zzz9secret; path=/; HttpOnly',
      );
      expect(out, isNot(contains('zzz9secret')));
      expect(out, startsWith('set-cookie: <redacted>'));
    });

    test('masks a bearer token mentioned outside a header', () {
      expect(
        redactDiagnosticMessage('retrying with Bearer qbt_8f3kd92jdk3lsd0'),
        'retrying with Bearer <redacted>',
      );
    });

    test('leaves prose that merely mentions "bearer" alone', () {
      const message = 'the bearer of bad news';
      expect(redactDiagnosticMessage(message), message);
    });
  });

  test('leaves ordinary text alone', () {
    const message = 'Radarr GET api/v3/movie failed | AuthError (HTTP 401)';
    expect(redactDiagnosticMessage(message), message);
  });
}
