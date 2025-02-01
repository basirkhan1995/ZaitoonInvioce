import 'package:flutter/material.dart';

class UnderlineTextfield extends StatelessWidget {
  final String title;
  final String? hintText;
  final Color enabledColor;
  final bool isRequired;
  final bool isEnabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const UnderlineTextfield({
    super.key,
    this.enabledColor = Colors.cyan,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.isEnabled = true,
    this.validator,
    required this.title,
    this.readOnly = false,
    this.hintText,
    this.onTap,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            isRequired
                ? Text(
                    " *",
                    style: TextStyle(color: Colors.red.shade900),
                  )
                : const SizedBox(),
          ],
        ),
        TextFormField(
          focusNode: focusNode,
          enabled: isEnabled,
          controller: controller,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          readOnly:
              readOnly, // Make the field read-only to prevent manual input.
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            hintText: hintText,
            hintStyle: TextStyle(color: enabledColor),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: enabledColor),
            ),
          ),
        ),
      ],
    );
  }
}
