import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/streams_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/ads_screen.dart';
import 'screens/bank_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/carteirinha_screen.dart';
import 'screens/faclube_screen.dart';
import 'screens/caravana_screen.dart';
import 'screens/flow_business_screen.dart';
import 'screens/radio_screen.dart';
import 'screens/podcast_screen.dart';

class Routes {
  static const home = '/';
  static const cadastro = '/cadastro';
  static const feed = '/feed';
  static const streams = '/streams';
  static const shop = '/shop';
  static const ads = '/ads';
  static const bank = '/bank';
  static const registro = '/registro';
  static const carteirinha = '/carteirinha';
  static const faclube = '/faclube';
  static const caravana = '/caravana';
  static const flowBusiness = '/flow';
  static const radio = '/radio';
  static const podcast = '/podcast';

  static Map<String, WidgetBuilder> get all => {
        home: (_) => const HomeScreen(),
        cadastro: (_) => const CadastroScreen(),
        feed: (_) => const FeedScreen(),
        streams: (_) => const StreamsScreen(),
        shop: (_) => const ShopScreen(),
        ads: (_) => const AdsScreen(),
        bank: (_) => const BankScreen(),
        registro: (_) => const RegistroScreen(),
        carteirinha: (_) => const CarteirinhaScreen(),
        faclube: (_) => const FaclubeScreen(),
        caravana: (_) => const CaravanaScreen(),
        flowBusiness: (_) => const FlowBusinessScreen(),
        radio: (_) => const RadioScreen(),
        podcast: (_) => const PodcastScreen(),
      };
}
