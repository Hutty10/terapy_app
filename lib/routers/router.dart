import 'package:flutter/material.dart'
    show GlobalKey, NavigatorState, BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import './route_notifier.dart';
import './route_names.dart';

import '../controllers/services/auth_service.dart';

final _key = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

/// This simple provider caches our GoRouter.
final routerProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authProvider);
    final notifier = ref.watch(routerNotifierProvider);

    return GoRouter(
      navigatorKey: _key,
      // refreshListenable: ,
      debugLogDiagnostics: true,
      initialLocation: RouteName.onboardingScreen.toPath(),
      routes: notifier.routes,
      redirect: (BuildContext context, GoRouterState state) =>
          notifier.redirect(
        context,
        state,
        authState,
        ref,
      ),
    );
  },
);
