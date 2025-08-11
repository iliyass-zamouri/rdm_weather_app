import 'package:flutter_test/flutter_test.dart';
import 'package:rdm_weather_app/features/app/presentation/pages/app_page.dart';

void main() {
  group('AppPage', () {
    test('should be instantiable', () {
      expect(() => AppPage(), returnsNormally);
    });

    test('should have correct class type', () {
      final appPage = AppPage();
      expect(appPage, isA<AppPage>());
    });
  });
}
