import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final Widget? tablet;

  const ResponsiveLayout({super.key, required this.mobile, required this.desktop, this.tablet});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1000) return desktop;
    if (width >= 600) return tablet ?? desktop;
    return mobile;
  }
}
