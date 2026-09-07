/// Hand-rolled relative-time formatter ("13h ago") for the Requests list —
/// no `intl`/`timeago` dependency exists elsewhere in this app, so this
/// covers the one place that needs it rather than adding a new package.
library;

String formatRelativeTime(DateTime dateTime) {
  final diff = DateTime.now().toUtc().difference(dateTime.toUtc());

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
  return '${(diff.inDays / 365).floor()}y ago';
}
