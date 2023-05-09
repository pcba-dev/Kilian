import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './home_page.dart';

/// Pages routes.
enum PagesRoutes {
  home,
}

extension PagesRoutesExtended on PagesRoutes {
  String get name {
    switch (this) {
      case PagesRoutes.home:
        return "home";
      default:
        return "404";
    }
  }

  String get path {
    switch (this) {
      case PagesRoutes.home:
        return "/";
      default:
        return "/404";
    }
  }
}

/// Web navigation router.
final GoRouter kRouter = new GoRouter(
  routes: <GoRoute>[
// Home page.
    new GoRoute(
      name: PagesRoutes.home.name,
      path: PagesRoutes.home.path,
      pageBuilder: (_, routerState) {
        return new NoTransitionPage<void>(
          key: routerState.pageKey,
          child: const HomePage(),
        );
      },
    ),
  ],
);

extension GoRouterExtended on BuildContext {
  /// Replace the current route of the navigator by navigating (GO) to the route named
  /// [name] and then disposing the previous route once the new route has
  /// finished animating in.
  void goReplacementNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    Router.neglect(
      this,
      () {
        GoRouter.of(this).pushNamed(
          name,
          pathParameters: params,
          queryParameters: queryParams,
          extra: extra,
        );
      },
    );
  }

  /// Replace the current route of the navigator by pushing the route named
  /// [name] and then disposing the previous route once the new route has
  /// finished animating in.
  void pushReplacementNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    Router.neglect(
      this,
      () {
        GoRouter.of(this).pushNamed(
          name,
          pathParameters: params,
          queryParameters: queryParams,
          extra: extra,
        );
      },
    );
  }
}
