// This is a basic Flutter widget test for the Portfolio app.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfollio/main.dart';

void main() {
  testWidgets('Portfolio app builds and pumps successfully', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: PortfolioApp()));

      // Verify that the widget tree has built and pumped a frame without crashing.
      expect(find.byType(ProviderScope), findsOneWidget);
    });
  });
}
