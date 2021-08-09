import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './get_started_screen.dart';
import './tabs_screen.dart';
import '../providers/app_data.dart';
import '../providers/user_data.dart';
import '../widgets/background_image.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () async {
        final appData = Provider.of<AppData>(context, listen: false);
        await appData.load(context);
        if (appData.isFirstRun) {
          Navigator.of(context)
              .pushReplacementNamed(GetStartedScreen.routeName);
        } else {
          MyApp.setLocale(context, Locale(appData.language));
          await Provider.of<UserData>(context, listen: false)
              .tryAutoLogin(context);
          Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: BackgroundImage(
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/images/logo.png', width: width),
            ),
          ),
        ),
      ),
    );
  }
}
