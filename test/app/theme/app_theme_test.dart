import 'package:arrstack/app/theme/app_theme.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dark theme uses the Nocturne muted tone for onSurfaceVariant', () {
    final scheme = AppTheme.dark().colorScheme;
    expect(scheme.onSurfaceVariant, AppColors.n400);
  });
}
