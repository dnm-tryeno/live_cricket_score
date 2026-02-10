import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for global keys (no codegen required)
final scaffoldMessengerKeyProvider =
    Provider<GlobalKey<ScaffoldMessengerState>>(
      (ref) => GlobalKey<ScaffoldMessengerState>(),
    );

// Singleton holders for access from non-provider code paths
GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKeySingleton;
