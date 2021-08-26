import 'package:flutter/material.dart';
import '../utils/field_theme.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextFormField textFormField;

  const InputField({required this.label, required this.textFormField});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Theme(
            data: inputTheme(context),
            child: textFormField,
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          start: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColorDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.9],
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.subtitle1!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
