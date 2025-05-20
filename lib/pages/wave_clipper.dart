import 'package:flutter/material.dart';
// ignore: unused_import

// ignore: unused_import
import 'package:valuebuyin/nav_bar.dart';
// ignore: unused_import
import 'package:valuebuyin/pages/wave_clipper.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Step 4: Define the custom shape
    path.lineTo(0, size.height - 40); // Start from bottom-left with offset

    // First curve
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Complete the shape
    path.lineTo(size.width, 0); // Move to top-right
    path.close(); // Close back to top-left

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to reclip unless the size changes
  }
}
