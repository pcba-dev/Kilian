import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:kilian/pages/router.dart';

import './widgets/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();

  usePathUrlStrategy(); // Configure Flutter to use the URL path.
  runApp(const KilianApp());
}

/// This is where the resources needed by your app are initialize while
/// the splash screen is displayed. After this function completes, the
/// splash screen will be removed.
Future<void> _initializeApp() async {}

class KilianApp extends StatelessWidget {
  const KilianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kilian',
      routerConfig: kRouter,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es', 'ES')],
      theme: kTheme,
    );
  }
}
