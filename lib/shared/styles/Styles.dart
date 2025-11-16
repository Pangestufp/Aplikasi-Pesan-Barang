import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Styles {
  static const Color primaryColor = Color(0xFF125E9C);
  static const Color secondaryColor = Color(0xFFF0F0F0);
  static const Color tertiaryColor = Color(0xFFC4D9E4);

  static final BoxDecoration radiusDown = BoxDecoration(
    color: secondaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        spreadRadius: 2,
        blurRadius: 8,
        offset: Offset(0, 4)
      ),
    ],
  );

  static final BoxDecoration radiusall = BoxDecoration(
    color: primaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    boxShadow: [
      BoxShadow(
          color: Colors.black26,
          spreadRadius: 2,
          blurRadius: 8,
          offset: Offset(0, 4)
      ),
    ],
  );

  static final BoxDecoration radiusDownTertiary = BoxDecoration(
    color: tertiaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
    boxShadow: [
      BoxShadow(
          color: Colors.black26,
          spreadRadius: 2,
          blurRadius: 8,
          offset: Offset(0, 4)
      ),
    ],
  );

  static InputDecoration roundedInput(String hint, {IconData icon = Icons.search}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: primaryColor,
      suffixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  static TextStyle whiteTextField() {
    return TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
  }

  static AppBar bar(String kata){
    return AppBar(
      title: Text(
        kata,
        style: TextStyle(color: Styles.primaryColor),
      ),
      centerTitle: true,
      backgroundColor: Styles.tertiaryColor,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Styles.primaryColor),
    );
  }

  static InputDecoration underlineInput(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  static InputDecoration dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: primaryColor),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  static String formatDate(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MM-dd-yyyy').format(dateTime);
  }

  static String formatMoneyRp(String? money){
    if(money==null){
      return "-";
    }
    return "Rp"+ NumberFormat.decimalPattern('id').format(double.parse(money.toString()).toInt());
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'selesai':
        return Colors.blue;
      case 'returned':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

}