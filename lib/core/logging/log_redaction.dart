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

String redactDiagnosticMessage(String message) {
  return message
      .replaceAllMapped(_secretParam, (m) => '${m[1]}$_redacted')
      .replaceAllMapped(_url, (m) => '${m[1]}://<host>')
      .replaceAll(_tailnetHost, '<host>')
      .replaceAll(_ipv6, '<host>')
      .replaceAll(_ipv4, '<host>')
      .replaceAll(_hexKey, _redacted);
}
