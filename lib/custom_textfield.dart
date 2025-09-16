import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final IconData? icon;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.type,
    this.icon,
    this.enabled = true, // default bisa diisi
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        enabled: enabled, // jika false, field readOnly
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return '$label harus diisi';
          }
          return null;
        },
      ),
    );
  }
}
