import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderLogo extends StatelessWidget {
  final double height;
  final String text;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  const HeaderLogo({
    super.key,
    required this.height,
    this.text = 'ride2go',
    this.fontSize = 48,
    this.backgroundColor = const Color(0xFF113469),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Stack(
        children: [
          // Header Background
          Container(
            color: backgroundColor,
          ),
          // Centered Logo
          Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
