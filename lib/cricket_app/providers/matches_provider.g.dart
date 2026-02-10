// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matches_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$matchesByTypeHash() => r'4a9fbff0184e754aa8ae87dec2192a8edcbabe4f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for getting matches filtered by type
///
/// Copied from [matchesByType].
@ProviderFor(matchesByType)
const matchesByTypeProvider = MatchesByTypeFamily();

/// Provider for getting matches filtered by type
///
/// Copied from [matchesByType].
class MatchesByTypeFamily extends Family<AsyncValue<List<MatchModel>>> {
  /// Provider for getting matches filtered by type
  ///
  /// Copied from [matchesByType].
  const MatchesByTypeFamily();

  /// Provider for getting matches filtered by type
  ///
  /// Copied from [matchesByType].
  MatchesByTypeProvider call(String matchType) {
    return MatchesByTypeProvider(matchType);
  }

  @override
  MatchesByTypeProvider getProviderOverride(
    covariant MatchesByTypeProvider provider,
  ) {
    return call(provider.matchType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'matchesByTypeProvider';
}

/// Provider for getting matches filtered by type
///
/// Copied from [matchesByType].
class MatchesByTypeProvider
    extends AutoDisposeFutureProvider<List<MatchModel>> {
  /// Provider for getting matches filtered by type
  ///
  /// Copied from [matchesByType].
  MatchesByTypeProvider(String matchType)
    : this._internal(
        (ref) => matchesByType(ref as MatchesByTypeRef, matchType),
        from: matchesByTypeProvider,
        name: r'matchesByTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$matchesByTypeHash,
        dependencies: MatchesByTypeFamily._dependencies,
        allTransitiveDependencies:
            MatchesByTypeFamily._allTransitiveDependencies,
        matchType: matchType,
      );

  MatchesByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.matchType,
  }) : super.internal();

  final String matchType;

  @override
  Override overrideWith(
    FutureOr<List<MatchModel>> Function(MatchesByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MatchesByTypeProvider._internal(
        (ref) => create(ref as MatchesByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        matchType: matchType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MatchModel>> createElement() {
    return _MatchesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchesByTypeProvider && other.matchType == matchType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, matchType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MatchesByTypeRef on AutoDisposeFutureProviderRef<List<MatchModel>> {
  /// The parameter `matchType` of this provider.
  String get matchType;
}

class _MatchesByTypeProviderElement
    extends AutoDisposeFutureProviderElement<List<MatchModel>>
    with MatchesByTypeRef {
  _MatchesByTypeProviderElement(super.provider);

  @override
  String get matchType => (origin as MatchesByTypeProvider).matchType;
}

String _$matchByIdHash() => r'7c905ebde28da67bf80f681d6c6d8669099184fa';

/// Provider for getting a specific match by ID
///
/// Copied from [matchById].
@ProviderFor(matchById)
const matchByIdProvider = MatchByIdFamily();

/// Provider for getting a specific match by ID
///
/// Copied from [matchById].
class MatchByIdFamily extends Family<AsyncValue<MatchModel?>> {
  /// Provider for getting a specific match by ID
  ///
  /// Copied from [matchById].
  const MatchByIdFamily();

  /// Provider for getting a specific match by ID
  ///
  /// Copied from [matchById].
  MatchByIdProvider call(String matchId) {
    return MatchByIdProvider(matchId);
  }

  @override
  MatchByIdProvider getProviderOverride(covariant MatchByIdProvider provider) {
    return call(provider.matchId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'matchByIdProvider';
}

/// Provider for getting a specific match by ID
///
/// Copied from [matchById].
class MatchByIdProvider extends AutoDisposeFutureProvider<MatchModel?> {
  /// Provider for getting a specific match by ID
  ///
  /// Copied from [matchById].
  MatchByIdProvider(String matchId)
    : this._internal(
        (ref) => matchById(ref as MatchByIdRef, matchId),
        from: matchByIdProvider,
        name: r'matchByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$matchByIdHash,
        dependencies: MatchByIdFamily._dependencies,
        allTransitiveDependencies: MatchByIdFamily._allTransitiveDependencies,
        matchId: matchId,
      );

  MatchByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.matchId,
  }) : super.internal();

  final String matchId;

  @override
  Override overrideWith(
    FutureOr<MatchModel?> Function(MatchByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MatchByIdProvider._internal(
        (ref) => create(ref as MatchByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        matchId: matchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MatchModel?> createElement() {
    return _MatchByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchByIdProvider && other.matchId == matchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, matchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MatchByIdRef on AutoDisposeFutureProviderRef<MatchModel?> {
  /// The parameter `matchId` of this provider.
  String get matchId;
}

class _MatchByIdProviderElement
    extends AutoDisposeFutureProviderElement<MatchModel?>
    with MatchByIdRef {
  _MatchByIdProviderElement(super.provider);

  @override
  String get matchId => (origin as MatchByIdProvider).matchId;
}

String _$matchesNotifierHash() => r'd4747f4e32be8b5c588b63b9ebeface07915babb';

/// State notifier for managing cricket matches data with pagination.
/// Live filter uses [CurrentMatchesNotifier] instead (auto-refresh).
///
/// Copied from [MatchesNotifier].
@ProviderFor(MatchesNotifier)
final matchesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      MatchesNotifier,
      CricketMatchesResponseModel
    >.internal(
      MatchesNotifier.new,
      name: r'matchesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$matchesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MatchesNotifier =
    AutoDisposeAsyncNotifier<CricketMatchesResponseModel>;
String _$matchFilterNotifierHash() =>
    r'b08e678460bb17269820e9aed862f71db6d28fe5';

/// Provider for the current match filter
///
/// Copied from [MatchFilterNotifier].
@ProviderFor(MatchFilterNotifier)
final matchFilterNotifierProvider =
    AutoDisposeNotifierProvider<MatchFilterNotifier, MatchFilterType>.internal(
      MatchFilterNotifier.new,
      name: r'matchFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$matchFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MatchFilterNotifier = AutoDisposeNotifier<MatchFilterType>;
String _$currentMatchesNotifierHash() =>
    r'4ce4455d3a29e09270c58c69329ddc9fdf2fe176';

/// Provider for current matches (live screen with auto-refresh).
/// Uses eCricScore + status text + time-based check to determine truly live.
///
/// Copied from [CurrentMatchesNotifier].
@ProviderFor(CurrentMatchesNotifier)
final currentMatchesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      CurrentMatchesNotifier,
      CurrentMatchesData
    >.internal(
      CurrentMatchesNotifier.new,
      name: r'currentMatchesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentMatchesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentMatchesNotifier = AutoDisposeAsyncNotifier<CurrentMatchesData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
