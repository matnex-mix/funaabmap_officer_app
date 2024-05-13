import 'package:funaabmap/models/artifact.dart';
import 'package:funaabmap/pages/artifacts/list.dart';
import 'package:funaabmap/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/artifacts/upsert.dart';
import '../pages/auth/login.dart';
import '../pages/splash.dart';

final router = GoRouter(
  // initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/artifacts',
      builder: (context, state) => ArtifactListScreen()
    ),
    GoRoute(
      path: '/artifacts/:id',
      builder: (context, state) => ArtifactUpsertScreen(pageId: state.pathParameters['id'], extra: state.extra as Artifact?),
    ),
    GoRoute(
      path: '/load',
      pageBuilder: (context, state) => CustomTransitionPage(
        fullscreenDialog: true,
        opaque: false,
        transitionsBuilder: (_, __, ___, child) => child,
        child: Widgets.load(dismissible: state.uri.queryParameters['dismissible'] == "1"),
      ),
    ),
  ],
);