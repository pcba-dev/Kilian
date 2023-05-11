import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:kilian/pages/router.dart';
import 'package:kilian/states/app_state.dart';

import './widgets/theme.dart';
import 'l10n/l10n.dart';

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
    return new StoreProvider(
      store: AppStore.instance,
      child: MaterialApp.router(
        title: 'Kilian',
        routerConfig: kRouter,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: kTheme,
      ),
    );
  }
}
