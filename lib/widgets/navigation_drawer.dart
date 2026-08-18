import 'package:flutter/material.dart';
import '../routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 28, backgroundColor: Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 8),
                  Text('IDM Cifras', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            _tile(context, 'Home', Routes.home),
            _tile(context, 'Cadastro Único', Routes.cadastro),
            _tile(context, 'Feed Infinito', Routes.feed),
            _tile(context, 'IDM Streams', Routes.streams),
            _tile(context, 'Loja / Mercado Livre', Routes.shop),
            _tile(context, 'Universal Ads', Routes.ads),
            _tile(context, 'Bank Invest', Routes.bank),
            _tile(context, 'Registro Legal', Routes.registro),
            _tile(context, 'Carteirinha de Músico', Routes.carteirinha),
            _tile(context, 'Fã Clube', Routes.faclube),
            _tile(context, 'Caravana IDM', Routes.caravana),
            _tile(context, 'Flow Business', Routes.flowBusiness),
            _tile(context, 'Rádio', Routes.radio),
            _tile(context, 'Podcast', Routes.podcast),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }
}
