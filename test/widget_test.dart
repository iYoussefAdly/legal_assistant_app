// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:legal_assistant_app/data/api/qanouny_api_service.dart';
import 'package:legal_assistant_app/data/repository/qanouny_repository.dart';
import 'package:legal_assistant_app/main.dart';
import 'package:legal_assistant_app/presentation/views/splash_view.dart';

void main() {
  testWidgets('LegalAssistantApp shows splash screen on launch',
      (WidgetTester tester) async {
    final repository = QanounyRepository(QanounyApiService());

    await tester.pumpWidget(LegalAssistantApp(repository: repository));

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
