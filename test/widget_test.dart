import 'package:flutter_test/flutter_test.dart';
import 'package:jets/main.dart';

void main() {
  testWidgets('JETS app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const JETSApp());

    expect(find.text('JETS'), findsWidgets);
  });
}