import 'package:flutter/material.dart';
import '../localizations/app_localizations.dart';

void loading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(title: Center(child: CircularProgressIndicator())),
    ),
  );
}

void alert(BuildContext context, String message, {void Function()? onOk}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          child: Text(t('ok')),
          onPressed: onOk == null
              ? () => Navigator.pop(context)
              : () {
            Navigator.pop(context);
            onOk();
          },
        ),
      ],
    ),
  );
}

void prompt(BuildContext context, String message,
    {void Function()? onYes, void Function()? onNo}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          child: Text(t('no')),
          onPressed: onNo == null
              ? () => Navigator.pop(context)
              : () {
                  Navigator.pop(context);
                  onNo();
                },
        ),
        TextButton(
          child: Text(t('yes')),
          onPressed: onYes == null
              ? () => Navigator.pop(context)
              : () {
                  Navigator.pop(context);
                  onYes();
                },
        ),
      ],
    ),
  );
}

void invalidToken(BuildContext context) {
  alert(context, t('invalid_token'));
}

void somethingWentWrong(BuildContext context) {
  alert(context, t('wrong'));
}

void somethingWentWrongPop(BuildContext context) {
  alert(context, t('wrong'), onOk: () => Navigator.pop(context));
}
