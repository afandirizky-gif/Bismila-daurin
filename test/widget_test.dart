import 'package:flutter_test/flutter_test.dart';
import 'package:daurin_app/main.dart';

void main() {
  testWidgets('DaurinApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DaurinApp());
    expect(find.byType(DaurinApp), findsOneWidget);
  });
}
