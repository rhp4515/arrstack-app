import 'package:arrstack/app/app.dart';
import 'package:flutter/widgets.dart' show runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: ArrStackApp()));
}
