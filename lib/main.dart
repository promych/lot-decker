import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show DeviceOrientation, SystemChrome, SystemUiOverlayStyle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './helpers/theme.dart';
import './managers/app_manager.dart';
import './managers/locale_manager.dart';
import './ui/error.dart';
import './ui/loading.dart';
import 'data/db_bloc.dart';
import 'helpers/constants.dart';
import 'screens/home_page/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return kReleaseMode ? Container() : ErrorWidget(details.exception);
  };

  runApp(App());
}

class App extends StatelessWidget {
  final _localeDelegates = <LocalizationsDelegate>[
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DbBloc>(
          create: (_) => DbBloc()..load(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<AppManager>(
          create: (_) => AppManager()..load(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
      ],
      child: Consumer<AppManager>(
        builder: (context, app, _) {
          return StreamBuilder<Locale>(
            stream: app.$locale,
            initialData: kAppLocales['EN'],
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              if (snapshot.hasError) {
                return ErrorView(message: snapshot.error);
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: appMaterialTheme,
                supportedLocales: kAppLocales.values,
                localizationsDelegates: _localeDelegates,
                locale: snapshot.data,
                home: HomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
