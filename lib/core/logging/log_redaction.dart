/// Scrubs anything identifying from a diagnostic log message before it is
/// stored (spec §11: "Redact keys/URLs in any logging"). The log exists to
/// be shared with someone else, so it must never carry an API key, a
/// password, or the address of the user's server.
library;

const String _redacted = '<redacted>';

final RegExp _url = RegExp(
  r'\b([a-zA-Z][a-zA-Z0-9+.-]*)://([^\s/?#"'
  "'"
  '<>]+)',
);
final RegExp _ipv4 = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}(?::\d+)?\b');
final RegExp _ipv6 = RegExp(r'\[[0-9a-fA-F:]+\](?::\d+)?');
final RegExp _tailnetHost = RegExp(
  r'\b[\w-]+(?:\.[\w-]+)*\.ts\.net(?::\d+)?\b',
  caseSensitive: false,
);
final RegExp _secretParam = RegExp(
  r'((?:api[_-]?key|apikey|token|password|passwd|pass|secret|auth)\s*[=:]\s*)'
  r'''("[^"]*"|'[^']*'|[^\s&,;]+)''',
  caseSensitive: false,
);

/// *arr API keys are 32 hex characters; catch any that slipped into a
/// message without a `key=` label in front of them.
final RegExp _hexKey = RegExp(r'\b[0-9a-fA-F]{32}\b');

/// A hostname given where a socket error names its target: Dart's
/// `Failed host lookup: 'nas.home'`, and the `address = nas.lan` /
/// `host: …` fields of a refused or reset connection. These hosts appear
/// bare — no scheme, often no dots — so neither [_url] nor the IP and
/// tailnet patterns can recognise them, and they are the most common thing
/// the request interceptor records.
final RegExp _hostLookup = RegExp(
  r'''(host lookup:\s*)(['"]?)([^'"\s,)]+)\2''',
  caseSensitive: false,
);
final RegExp _hostField = RegExp(
  r'''(\b(?:address|host)\s*[:=]\s*)(?!<host>)([^\s,;'"()]+)''',
  caseSensitive: false,
);

/// A bare `host:port`, as this app's own error copy prints its targets
/// ("Couldn't look up nas:7878.", "nas:7878 did not respond"). The first
/// character must be a letter at a word boundary, which keeps ISO times
/// out: in `2026-09-30T12:00` the `T` is glued to digits, so there is no
/// boundary before it and `T12:00` can't start a match.
final RegExp _hostPort = RegExp(
  r'\b[a-zA-Z][a-zA-Z0-9-]*(?:\.[a-zA-Z0-9-]+)*:\d{2,5}\b',
);

/// An `Authorization` header's credential, whatever the scheme. The labelled
/// pattern above can't catch it: it needs `auth` directly before the colon,
/// and "Authorization" has "orization" in between — so a qBittorrent
/// `Authorization: Bearer <api key>` went through untouched. The scheme word
/// is kept, since "Bearer" vs "Basic" is useful when diagnosing; only the
/// credential after it is masked. Basic credentials are base64 of
/// `user:password`, so they need masking as much as a token does.
final RegExp _authHeader = RegExp(
  r'(\b(?:proxy-)?authorization\s*[:=]\s*(?:[a-z]+\s+)?)([^\s,;]+)',
  caseSensitive: false,
);

/// A bearer token mentioned outside a header. The 8-character floor keeps
/// ordinary prose ("bearer of …") out of it.
final RegExp _bearer = RegExp(
  r'(\bbearer\s+)([A-Za-z0-9._~+/=-]{8,})',
  caseSensitive: false,
);

/// Every `name=value` pair in a `Cookie` or `Set-Cookie` header. A session
/// cookie is a login — qBittorrent's `SID` is as good as its password — and
/// cookie names vary by service, so all values go rather than a list of
/// known names.
final RegExp _cookieHeader = RegExp(
  r'(\b(?:set-)?cookie\s*[:=]\s*)((?:[^=;\s]+=[^;\s]*(?:;\s*)?)+)',
  caseSensitive: false,
);

String redactDiagnosticMessage(String message) {
  return message
      // Headers first, so they claim their whole credential before the
      // narrower patterns below see a piece of it.
      .replaceAllMapped(_authHeader, (m) => '${m[1]}$_redacted')
      .replaceAllMapped(_cookieHeader, (m) => '${m[1]}$_redacted')
      .replaceAllMapped(_bearer, (m) => '${m[1]}$_redacted')
      .replaceAllMapped(_secretParam, (m) => '${m[1]}$_redacted')
      .replaceAllMapped(_url, (m) => '${m[1]}://<host>')
      // After URLs, so a host inside a URL is already gone and only bare
      // ones are left for these.
      .replaceAllMapped(_hostLookup, (m) => '${m[1]}${m[2]}<host>${m[2]}')
      .replaceAllMapped(_hostField, (m) => '${m[1]}<host>')
      .replaceAll(_hostPort, '<host>')
      .replaceAll(_tailnetHost, '<host>')
      .replaceAll(_ipv6, '<host>')
      .replaceAll(_ipv4, '<host>')
      .replaceAll(_hexKey, _redacted);
}
