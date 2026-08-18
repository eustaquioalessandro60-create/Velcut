import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

class IDMCifrasApp extends StatelessWidget {
  const IDMCifrasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDMCifras — Ecossistema',
      theme: idmTheme,
      initialRoute: Routes.home,
      routes: Routes.all,
      debugShowCheckedModeBanner: false,
    );
  }
}
