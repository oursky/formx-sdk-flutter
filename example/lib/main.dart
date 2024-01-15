import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formx_sdk_flutter/formx_sdk_flutter.dart';
import 'package:formx_sdk_flutter_example/screens/camera_screen.dart';
import 'package:formx_sdk_flutter_example/screens/extraction_screen.dart';
import 'package:formx_sdk_flutter_example/screens/home_screen.dart';
import 'package:formx_sdk_flutter_example/screens/preview_image_screen.dart';
import 'package:formx_sdk_flutter_example/screens/sdk_methods_demo_screen.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  await dotenv.load();

  final apiHost = dotenv.maybeGet("FORMX_API_HOST", fallback: "")!;
  await FormXSDK.init(
    extractorId: dotenv.env["FORMX_EXTRACTOR_ID"] ?? "<FILL_IN_EXTRACTOR_ID>",
    accessToken: dotenv.env["FORMX_ACCESS_TOKEN"] ?? "<FILL_IN_ACCESS_TOKEN>",
    apiHost: apiHost.isNotEmpty ? apiHost : null,
  );
  runApp(const MyApp());
}

final _router = GoRouter(routes: [
  GoRoute(path: "/", builder: (_, __) => const HomeScreen()),
  GoRoute(
    path: "/sdk_demo",
    builder: (_, __) => const SDKMethodsDemoScreen(),
  ),
  GoRoute(
    path: "/camera",
    builder: (_, __) => const CameraScreen(),
  ),
  GoRoute(
    path: "/preview",
    builder: (_, state) => PreviewImageScreen(state.extra as Uri),
  ),
  GoRoute(
    path: "/extraction",
    builder: (_, state) => ExtractionScreen(state.extra as Uri),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
