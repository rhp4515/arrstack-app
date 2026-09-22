/// Reading JSON collections without silently inventing an empty one.
///
/// Every list parser in the app used to open with `if (data is! List) return
/// []`, which turns "the server sent something that isn't our API" into a
/// successful empty result. That is indistinguishable from a healthy service
/// with nothing in it, so the caller reports the instance reachable and
/// shows `0 movies`. Two ways that bites:
///
///  * A reverse proxy or SSO gateway in front of the service answers 200
///    with an HTML login page instead of 401. Green dot, zero items.
///  * The real response is enveloped and the parser expected a bare list —
///    Bazarr's paged endpoints return `{data: [...], total: N}`, so its
///    wanted-subtitle count was always zero by construction.
///
/// An unexpected shape is a failure, and [jsonList] makes it one.
library;

/// The list at the root of a JSON response, or inside [envelopeKey] when the
/// service wraps it.
///
/// Throws [FormatException] for anything else, which `dioCall` surfaces as a
/// `ValidationError` — the caller sees a failure rather than an empty
/// success. [what] names the collection in that message.
///
/// The message never includes the response body: an error payload can echo
/// back a query string, and these messages reach the UI.
List<Map<String, dynamic>> jsonList(
  dynamic data, {
  required String what,
  String? envelopeKey,
}) {
  if (data is List) return _asObjects(data, what);

  if (envelopeKey != null && data is Map) {
    final inner = data[envelopeKey];
    if (inner is List) return _asObjects(inner, what);
  }

  throw FormatException(
    envelopeKey == null
        ? 'Expected a list of $what but the server sent '
              '${_describe(data)}. Check the URL points at the service.'
        : 'Expected a list of $what, or one under "$envelopeKey", but the '
              'server sent ${_describe(data)}. Check the URL points at the '
              'service.',
  );
}

List<Map<String, dynamic>> _asObjects(List<dynamic> list, String what) {
  final objects = list.whereType<Map<String, dynamic>>().toList();
  if (objects.length != list.length) {
    throw FormatException(
      'Expected every $what entry to be an object; '
      '${list.length - objects.length} of ${list.length} were not.',
    );
  }
  return objects;
}

/// A shape name for the message — never the content.
String _describe(dynamic data) => switch (data) {
  null => 'an empty response',
  String() => 'text (an HTML error or login page, most likely)',
  Map() => 'a single object',
  num() || bool() => 'a bare value',
  _ => 'something unexpected',
};
