import 'package:flutter/material.dart';

// Warna mengikuti identitas sidebar dan app bar yang sudah ada.
const Color kPrimaryBlue = Color(0xFF3B82F6);
const Color kTextDark = Color(0xFF0F172A);
const Color kTextMuted = Color(0xFF64748B);
const Color kBorder = Color(0xFFE2E8F0);
const Color kInputBorder = Color(0xFFCBD5E1);
const Color kFieldFill = Color(0xFFF1F5F9);
const Color kErrorRed = Color(0xFFDC2626);

InputDecoration inputDecoration({
  String? hintText,
  Widget? suffixIcon,
  bool readOnly = false,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: kTextMuted, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    filled: readOnly,
    fillColor: kFieldFill,
    suffixIcon: suffixIcon,
    border: border(kInputBorder),
    enabledBorder: border(kInputBorder),
    focusedBorder: border(kPrimaryBlue, 2),
    errorBorder: border(kErrorRed),
    focusedErrorBorder: border(kErrorRed, 2),
  );
}

Widget fieldLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: kTextDark,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget labeledField(String label, Widget field) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      fieldLabel(label),
      const SizedBox(height: 6),
      field,
    ],
  );
}

class FormErrorBanner extends StatelessWidget {
  const FormErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFECACA)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFB91C1C), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
