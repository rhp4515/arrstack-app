// jsonList: an unexpected response shape is a failure, not an empty list.
//
// The pattern this replaces (`if (data is! List) return []`) reported a
// healthy service with nothing in it whenever the server sent something
// that wasn't the API — so a green dot and `0 movies` covered both an SSO
// login page returned with a 200, and an enveloped response the parser
// never understood.

import 'package:arrstack/core/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads a bare list of objects', () {
    final result = jsonList([
      {'id': 1},
      {'id': 2},
    ], what: 'movies');

    expect(result, hasLength(2));
    expect(result.first['id'], 1);
  });

  test('accepts an empty list — a service with nothing in it is not an '
      'error', () {
    expect(jsonList(const [], what: 'movies'), isEmpty);
  });

  test('reads an enveloped list when the service wraps it', () {
    // Bazarr's paged endpoints: {data: [...], total: N}.
    final result = jsonList(
      {
        'data': [
          {'title': 'Ep 1'},
        ],
        'total': 1,
      },
      what: 'wanted episodes',
      envelopeKey: 'data',
    );

    expect(result, hasLength(1));
    expect(result.first['title'], 'Ep 1');
  });

  test('rejects an envelope when the caller expects a bare list, rather '
      'than quietly finding nothing', () {
    expect(
      () => jsonList({'data': <dynamic>[]}, what: 'movies'),
      throwsA(isA<FormatException>()),
    );
  });

  group('rejects a response that is not the API at all', () {
    test('an HTML login page returned with a 200', () {
      expect(
        () => jsonList('<html><body>Sign in</body></html>', what: 'movies'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            allOf(contains('text'), contains('movies')),
          ),
        ),
      );
    });

    test('an empty body', () {
      expect(
        () => jsonList(null, what: 'movies'),
        throwsA(isA<FormatException>()),
      );
    });

    test('a single object where a list belongs', () {
      expect(
        () => jsonList({'id': 1}, what: 'movies'),
        throwsA(isA<FormatException>()),
      );
    });

    test('a bare value', () {
      expect(
        () => jsonList(42, what: 'movies'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => jsonList(true, what: 'movies'),
        throwsA(isA<FormatException>()),
      );
    });

    test('an envelope whose key holds something other than a list', () {
      expect(
        () => jsonList(
          {'data': 'nope'},
          what: 'wanted episodes',
          envelopeKey: 'data',
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  test('rejects a list with non-object entries instead of silently dropping '
      'them, and says how many', () {
    expect(
      () => jsonList([
        {'id': 1},
        'junk',
      ], what: 'movies'),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('1 of 2'),
        ),
      ),
    );
  });

  test('never echoes the response body, which can carry a key in an error '
      'payload', () {
    const secret = 'apikey=super-secret';
    expect(
      () => jsonList(secret, what: 'movies'),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          isNot(contains('super-secret')),
        ),
      ),
    );
  });
}
