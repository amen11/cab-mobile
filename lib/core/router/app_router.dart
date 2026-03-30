import 'package:cab_app/features/main-shell/main_shell.dart';
import 'package:cab_app/features/matches/match_screen.dart';
import 'package:cab_app/features/news/news_list_card.dart';
import 'package:cab_app/features/news/news_list_screen.dart';
import 'package:cab_app/features/settings/settings_screen.dart';
import 'package:cab_app/features/tickets/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/matches/match_detail_screen.dart';
import '../../features/shop/shop_screen.dart';
import '../../features/shop/product_detail_screen.dart';
import '../../features/shop/cart_screen.dart';
import '../../features/shop/checkout_screen.dart';
 
class AppRouter {
  static final _rootKey = GlobalKey<NavigatorState>();
  static final _shellKey = GlobalKey<NavigatorState>();
 
  static final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (c, s) => const HomeScreen(),
          ),
          GoRoute(
            path: '/matches',
            builder: (c, s) => const MatchesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootKey,
                builder: (c, s) =>
                    MatchDetailScreen(matchId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/news',
            builder: (c, s) => const NewsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootKey,
                builder: (c, s) =>
                    NewsDetailScreen(newsId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/tickets',
            builder: (c, s) => const TicketsScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (c, s) => const ShopScreen(),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootKey,
                builder: (c, s) =>
                    ProductDetailScreen(productId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (c, s) => const SettingsScreen(),
          ),
        ],
      ),
      // Full-screen routes (above shell)
      GoRoute(
        path: '/cart',
        parentNavigatorKey: _rootKey,
        builder: (c, s) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: _rootKey,
        builder: (c, s) => const CheckoutScreen(),
      ),
    ],
  );
}
 