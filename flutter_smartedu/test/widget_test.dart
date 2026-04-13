import 'package:flutter_test/flutter_test.dart';
import 'package:smartedu/main.dart';

void main() {
  testWidgets('SmartEdu bootstraps the splash experience',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SmartEduApp());
    await tester.pump();

    expect(find.text('SmartEdu'), findsOneWidget);
    expect(find.text('Smart Classroom Solution'), findsOneWidget);
  });
}
