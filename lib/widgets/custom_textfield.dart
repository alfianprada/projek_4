import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final IconData? icon;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.type,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) =>
            value == null || value.isEmpty ? "$label tidak boleh kosong" : null,
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, color: const Color.fromARGB(255, 132, 53, 229)) 
              : null,
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
