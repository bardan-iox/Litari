import 'package:flutter_test/flutter_test.dart';
import 'package:litari/main.dart';

void main() {
  testWidgets('Litari app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LitariApp());
    expect(find.byType(LitariApp), findsOneWidget);
  });
}
