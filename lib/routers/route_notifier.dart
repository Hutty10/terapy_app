import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/services/local_db_service.dart';

import './route_exports.dart';
import './route_names.dart';

class RouterNotifier {
  /// Redirects the user when our authentication changes
  FutureOr<String?> redirect(BuildContext context, GoRouterState state,
      AsyncValue<User?> authState, ProviderRef ref) async {
    // final authState = ref.watch(authProvider);

    final hasOnboarded = await ref.read(localDbProvider).readOnboarding();
    final isOnboarding = state.location == RouteName.onboardingScreen.toPath();
    if (isOnboarding) {
      return hasOnboarded
          ? RouteName.loginScreen.toPath()
          : RouteName.onboardingScreen.toPath();
    }

    // If our async state is loading, don't perform redirects, yet
    if (authState.isLoading || authState.hasError) return null;

    // This has to do with how the FirebaseAuth SDK handles the "log-in" state
    // Returning `null` means "we are not authorized"
    final isAuth = authState.valueOrNull != null;

    // final isSplash = state.location == SplashPage.routeLocation;
    // if (isSplash) {
    //   return isAuth ? HomePage.routeLocation : LoginPage.routeLocation;
    // }

    final isLoggingIn = state.location == RouteName.loginScreen.toPath();
    if (isLoggingIn) return isAuth ? RouteName.homeScreen.toPath() : null;

    final isSignUp = state.location == RouteName.signupScreen.toPath();
    if (isSignUp) return isAuth ? RouteName.homeScreen.toPath() : null;
    // return isAuth ? null : SplashPage.routeLocation;
    return null;
  }

  /// Our application routes. Obtained through code generation
  List<GoRoute> get routes => [
        GoRoute(
          name: RouteName.onboardingScreen,
          path: RouteName.onboardingScreen.toPath(),
          builder: (context, state) => const OnboardingView(),
        ),
        GoRoute(
          name: RouteName.loginScreen,
          path: RouteName.loginScreen.toPath(),
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          name: RouteName.signupScreen,
          path: RouteName.signupScreen.toPath(),
          builder: (context, state) => const SignUpView(),
        ),
        GoRoute(
          path: '/:tab(home|cart|chat|profile)',
          // name: RouteName.main,
          builder: (context, state) {
            final tab = state.params['tab']!;
            return MainView(tab: tab);
          },
        ),
        GoRoute(
          name: RouteName.homeScreen,
          path: RouteName.homeScreen.toPath(),
          redirect: (context, state) => RouteName.homeScreen,
        ),
        GoRoute(
          name: RouteName.chatScreen,
          path: RouteName.chatScreen.toPath(),
          redirect: (context, state) => RouteName.cartScreen,
        ),
        GoRoute(
          name: RouteName.cartScreen,
          path: RouteName.cartScreen.toPath(),
          redirect: (context, state) => RouteName.chatScreen,
        ),
        GoRoute(
          name: RouteName.profileScreen,
          path: RouteName.profileScreen.toPath(),
          redirect: (context, state) => RouteName.profileScreen,
        ),
      ];
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier();
});
