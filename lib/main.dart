import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/utils/colors.dart';
import 'package:rdm_weather_app/features/app/presentation/pages/app_page.dart';
import 'core/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const ProviderScope(
    child: WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDM Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: AppColors.primarySwatch),
      home: const AppPage(),
    );
  }
}
