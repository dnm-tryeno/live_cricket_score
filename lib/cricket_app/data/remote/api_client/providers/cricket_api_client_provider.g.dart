// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cricket_api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cricketApiClientHash() => r'54764e6952d3fc8a14ad2fec3e2f2c4dd41a371d';

/// Provides a configured instance of CricketApiClient
///
/// Sets up Dio with interceptors for error handling and logging
///
/// Copied from [cricketApiClient].
@ProviderFor(cricketApiClient)
final cricketApiClientProvider = AutoDisposeProvider<CricketApiClient>.internal(
  cricketApiClient,
  name: r'cricketApiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cricketApiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CricketApiClientRef = AutoDisposeProviderRef<CricketApiClient>;
String _$cricketApiKeyHash() => r'1d2e454137cfc07725eba854a35f647c77067b84';

/// Provider for API key (read from .env file)
///
/// Copied from [cricketApiKey].
@ProviderFor(cricketApiKey)
final cricketApiKeyProvider = AutoDisposeProvider<String>.internal(
  cricketApiKey,
  name: r'cricketApiKeyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cricketApiKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CricketApiKeyRef = AutoDisposeProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
