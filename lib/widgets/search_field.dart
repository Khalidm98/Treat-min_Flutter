import 'package:flutter/material.dart';
import '../utils/field_theme.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchField({
    @required this.controller,
    @required this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: inputTheme(context),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText,
          suffixIcon: IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              FocusScope.of(context).unfocus();
              controller.clear();
              onChanged('');
            },
          ),
        ),
      ),
    );
  }
}
