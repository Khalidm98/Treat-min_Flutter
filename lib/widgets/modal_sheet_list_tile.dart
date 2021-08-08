import 'package:flutter/material.dart';

class ModalSheetListTile extends StatelessWidget {
  final String text;
  final bool value;
  final Function onSwitchChange;

  ModalSheetListTile(
      {@required this.text,
      @required this.value,
      @required this.onSwitchChange});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      title: Text(text),
      trailing: Switch(
        value: value,
        onChanged: (value) {
          onSwitchChange();
        },
        activeColor: theme.primaryColor,
      ),
    );
  }
}
