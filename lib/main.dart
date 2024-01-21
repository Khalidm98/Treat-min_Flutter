import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'localizations/app_localizations.dart';
import 'providers/app_data.dart';
import 'providers/user_data.dart';

import 'screens/about_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/available_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/first_aid_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/info_screen.dart';
import 'screens/password_screen.dart';
import 'screens/select_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/verification_screen.dart';

void main() {
  // Set device orientation to only Portrait up
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  static const _greenLight = const Color(0xFF60C0A0);
  static const _green = const Color(0xFF40B080);
  static const _greenDark = const Color(0xFF20A060);
  static const _blue = const Color(0xFF205070);
  static const _red = const Color(0xFFA01010);
  Locale? _locale;

  void setLocale(Locale locale) => setState(() => _locale = locale);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppData()),
        ChangeNotifierProvider(create: (_) => UserData()),
      ],
      child: MaterialApp(
        title: 'Treat-min',
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: [
          const Locale('en', ''),
          const Locale('ar', 'EG'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (Locale locale in supportedLocales) {
            if (locale.languageCode == deviceLocale!.languageCode) {
              return locale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: _green,
          primaryColorDark: _greenDark,
          primaryColorLight: _greenLight,
          dividerColor: _blue,
          colorScheme: ColorScheme.light(
            primary: _green,
            secondary: _blue,
            error: _red,
          ),
          appBarTheme: const AppBarTheme(centerTitle: true),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(_greenDark),
              overlayColor: MaterialStateProperty.all<Color>(
                _greenLight.withOpacity(0.2),
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                const Size(double.infinity, 50),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(color: _red),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                _red.withOpacity(0.2),
              ),
              overlayColor: MaterialStateProperty.all<Color>(
                _red.withOpacity(0.4),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(_red),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                _blue.withOpacity(0.2),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(_blue),
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          textTheme: const TextTheme(
            button: const TextStyle(fontWeight: FontWeight.w700),
            headline4: const TextStyle(
                fontWeight: FontWeight.w700, color: Colors.black, height: 1.2),
            headline5: const TextStyle(
                fontWeight: FontWeight.w700, color: _blue, height: 1.2),
            headline6: const TextStyle(fontWeight: FontWeight.w500),
            subtitle1:
                const TextStyle(fontWeight: FontWeight.w700, height: 1.2),
            bodyText2:
                const TextStyle(fontWeight: FontWeight.w500, height: 1.2),
            caption: const TextStyle(fontWeight: FontWeight.w500),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: _greenLight,
            selectionColor: _greenLight,
            selectionHandleColor: _greenLight,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          AboutScreen.routeName: (_) => AboutScreen(),
          AuthScreen.routeName: (_) => AuthScreen(),
          AvailableScreen.routeName: (_) => AvailableScreen(),
          BookingScreen.routeName: (_) => BookingScreen(),
          ContactScreen.routeName: (_) => ContactScreen(),
          EmergencyScreen.routeName: (_) => EmergencyScreen(),
          FirstAidScreen.routeName: (_) => FirstAidScreen(),
          GetStartedScreen.routeName: (_) => GetStartedScreen(),
          InfoScreen.routeName: (_) => InfoScreen(),
          PasswordScreen.routeName: (_) => PasswordScreen(),
          SelectScreen.routeName: (_) => SelectScreen(),
          TabsScreen.routeName: (_) => TabsScreen(),
          VerificationScreen.routeName: (_) => VerificationScreen(),
        },
      ),
    );
  }
}
