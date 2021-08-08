import 'package:flutter/material.dart';
import '../localizations/app_localizations.dart';
import '../screens/auth_screen.dart' show AuthMode;

enum Social { google, facebook }

class SocialButton extends StatelessWidget {
  final AuthMode mode;
  final Social social;

  SocialButton(this.mode, this.social);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/icons/${social == Social.google ? 'google' : 'facebook'}.png',
          height: 30,
        ),
        label: Text(
          '${t(mode == AuthMode.signUp ? 'sign_up' : 'log_in')} '
          '${t(social == Social.google ? 'google' : 'facebook')}',
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            social == Social.google ? Colors.white : Colors.indigo[600],
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            social == Social.google ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
