import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

/// Provider that exposes the GoRouter instance through Riverpod
/// 
/// This allows widgets to access routing functionality via dependency injection
/// while maintaining centralized navigation configuration through AppRouter
final navigationProvider = Provider<GoRouter>(
  (ref) => AppRouter.router,
  name: 'NavigationProvider',
);
