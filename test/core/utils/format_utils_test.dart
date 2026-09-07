import 'package:arrstack/core/utils/format_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormatUtils.formatReleaseAge', () {
    test('renders minutes under an hour', () {
      expect(FormatUtils.formatReleaseAge(42), '42m');
    });
    test('renders whole hours under a day', () {
      expect(FormatUtils.formatReleaseAge(200), '3h');
    });
    test('renders whole days beyond a day', () {
      expect(FormatUtils.formatReleaseAge(60 * 24 * 5), '5d');
    });
    test('renders "just now" for zero or negative', () {
      expect(FormatUtils.formatReleaseAge(0), 'just now');
      expect(FormatUtils.formatReleaseAge(-3), 'just now');
    });
  });
}
