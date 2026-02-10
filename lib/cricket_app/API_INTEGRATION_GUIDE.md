# Cricket App - API Integration Guide

This guide explains how the API calling system works in the cricket app, following the same pattern as the cricket app app.

## Architecture Overview

The API architecture follows a clean, layered approach similar to the cricket app app:

```
UI Layer (Widgets/Screens)
    ↓
State Management (Riverpod Providers/Notifiers)
    ↓
Repository Layer (Data abstraction)
    ↓
API Client (Retrofit + Dio)
    ↓
Interceptors (Authentication, Logging, Error Handling)
    ↓
Network
```

## Project Structure

```
lib/cricket_app/
├── data/
│   ├── models/                          # Data models
│   │   ├── match_model.dart
│   │   ├── team_info_model.dart
│   │   ├── score_model.dart
│   │   ├── api_info_model.dart
│   │   └── cricket_matches_response_model.dart
│   ├── remote/
│   │   ├── api_client/                  # API client
│   │   │   ├── cricket_api_client.dart  # Retrofit API interface
│   │   │   ├── custom_log_interceptor.dart
│   │   │   └── providers/
│   │   │       └── cricket_api_client_provider.dart
│   │   └── api_error_handling/          # Error handling
│   │       ├── model/
│   │       │   ├── error_type.dart
│   │       │   ├── error_messages.dart
│   │       │   ├── error_info.dart
│   │       │   └── api_error_model.dart
│   │       ├── exceptions/
│   │       │   └── api_exceptions.dart
│   │       ├── error_interceptor.dart
│   │       └── interceptor_error_handler.dart
│   └── repositories/                    # Data layer
│       ├── cricket_repository.dart
│       └── providers/
│           └── cricket_repository_provider.dart
├── providers/                           # State management
│   └── matches_provider.dart
└── utils/
    └── error_handler_util.dart
```

## Setup Instructions

### 1. Install Dependencies

Run the following command to install all required packages:

```bash
flutter pub get
```

### 2. Generate Code

Run build_runner to generate all the necessary code (Freezed models, JSON serialization, Retrofit, Riverpod):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `.freezed.dart` files for immutable models
- `.g.dart` files for JSON serialization
- `.g.dart` files for Retrofit API client
- `.g.dart` files for Riverpod providers

### 3. Configure API Key

Update the API key in `cricket_api_client_provider.dart`:

```dart
@riverpod
String cricketApiKey(CricketApiKeyRef ref) {
  return 'YOUR_ACTUAL_API_KEY_HERE';
}
```

### 4. Verify Base URL

Check the base URL in `cricket_api_client_provider.dart`:

```dart
const baseUrl = 'https://api.cricapi.com/v1/';
```

## Key Components

### 1. Models (Freezed + JSON Serializable)

All data models use Freezed for immutability and JSON serialization:

```dart
@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    required String id,
    required String name,
    required String matchType,
    // ... other fields
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}
```

### 2. API Client (Retrofit + Dio)

The API client is defined using Retrofit annotations:

```dart
@RestApi()
abstract class CricketApiClient {
  factory CricketApiClient(Dio dio, {String? baseUrl}) = _CricketApiClient;

  @GET('cricketapi')
  Future<CricketMatchesResponseModel> getAllMatches({
    @Query('apikey') required String apiKey,
  });

  @GET('cricketapi')
  Future<CricketMatchesResponseModel> getLiveMatches({
    @Query('apikey') required String apiKey,
    @Query('status') @Default('live') String status,
  });
}
```

### 3. Interceptors

**Error Interceptor**: Automatically converts Dio errors to custom API exceptions
**Logger Interceptor**: Logs all requests and responses, adds authentication token

### 4. Repository Layer

Provides a clean interface for data access:

```dart
class CricketRepository {
  final CricketApiClient _apiClient;
  final String _apiKey;

  Future<CricketMatchesResponseModel> getAllMatches() async {
    return await _apiClient.getAllMatches(apiKey: _apiKey);
  }
}
```

### 5. State Management (Riverpod)

AsyncNotifier manages state with loading, data, and error states:

```dart
@riverpod
class MatchesNotifier extends _$MatchesNotifier {
  @override
  Future<CricketMatchesResponseModel> build() async {
    return fetchMatches();
  }

  Future<void> changeFilter(MatchFilterType filter) async {
    // ... implementation
  }
}
```

## Usage in Screens

### Example: Displaying Matches List

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/matches_provider.dart';
import '../utils/error_handler_util.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the matches provider
    final matchesAsync = ref.watch(matchesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cricket Matches')),
      body: matchesAsync.when(
        // Loading state
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // Error state
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ErrorHandlerUtil.getErrorMessage(error)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry by refreshing
                  ref.read(matchesNotifierProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        // Success state with data
        data: (response) {
          final matches = response.data;

          if (matches.isEmpty) {
            return const Center(
              child: Text('No matches found'),
            );
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return ListTile(
                title: Text(match.name),
                subtitle: Text(match.status),
                trailing: Text(match.matchType.toUpperCase()),
                onTap: () {
                  // Navigate to match details
                },
              );
            },
          );
        },
      ),

      // Filter buttons
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                ref.read(matchesNotifierProvider.notifier)
                  .changeFilter(MatchFilterType.all);
              },
              child: const Text('All'),
            ),
            TextButton(
              onPressed: () {
                ref.read(matchesNotifierProvider.notifier)
                  .changeFilter(MatchFilterType.live);
              },
              child: const Text('Live'),
            ),
            TextButton(
              onPressed: () {
                ref.read(matchesNotifierProvider.notifier)
                  .changeFilter(MatchFilterType.upcoming);
              },
              child: const Text('Upcoming'),
            ),
            TextButton(
              onPressed: () {
                ref.read(matchesNotifierProvider.notifier)
                  .changeFilter(MatchFilterType.finished);
              },
              child: const Text('Finished'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Example: Displaying Match Details

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/matches_provider.dart';

class MatchDetailsScreen extends ConsumerWidget {
  final String matchId;

  const MatchDetailsScreen({
    super.key,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific match by ID
    final matchAsync = ref.watch(matchByIdProvider(matchId));

    return Scaffold(
      appBar: AppBar(title: const Text('Match Details')),
      body: matchAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (match) {
          if (match == null) {
            return const Center(
              child: Text('Match not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('Venue: ${match.venue}'),
                Text('Date: ${match.date}'),
                Text('Status: ${match.status}'),
                const SizedBox(height: 16),

                // Display teams
                Text(
                  'Teams',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ...match.teamInfo.map((team) => ListTile(
                  leading: Image.network(team.img),
                  title: Text(team.name),
                  subtitle: Text(team.shortname ?? ''),
                )),

                const SizedBox(height: 16),

                // Display scores
                if (match.score.isNotEmpty) ...[
                  Text(
                    'Scores',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...match.score.map((score) => Card(
                    child: ListTile(
                      title: Text(score.inning),
                      subtitle: Text(
                        '${score.r}/${score.w} (${score.o} overs)',
                      ),
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## Error Handling

### Automatic Error Conversion

The `ErrorInterceptor` automatically converts Dio exceptions to typed API exceptions:

- `NetworkException` - No internet connection, timeouts
- `AuthenticationException` - 401/403 errors
- `ServerException` - 5xx errors
- `ClientException` - 4xx errors (validation, bad request)
- `UnknownException` - Other errors

### Displaying Errors

Use the `ErrorHandlerUtil` to show errors to users:

```dart
try {
  final response = await ref.read(cricketRepositoryProvider).getAllMatches();
} catch (error) {
  if (mounted) {
    ErrorHandlerUtil.showErrorDialog(context, error, onRetry: () {
      // Retry logic
    });

    // Or show a snackbar
    ErrorHandlerUtil.showErrorSnackBar(context, error);
  }
}
```

## Testing the API

### 1. Check API Connection

```dart
// In a test screen or debug panel
ElevatedButton(
  onPressed: () async {
    try {
      final repo = ref.read(cricketRepositoryProvider);
      final response = await repo.getAllMatches();
      print('API Success: ${response.data.length} matches found');
    } catch (e) {
      print('API Error: $e');
    }
  },
  child: const Text('Test API Connection'),
)
```

### 2. Monitor Console Logs

The `CustomLoggerInterceptor` will log all requests and responses:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌐 API REQUEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
URL: https://api.cricapi.com/v1/cricketapi
METHOD: GET
HEADERS: {content-type: application/json, ...}
QUERY PARAMS: {apikey: xxx, status: live}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Advantages of This Architecture

1. **Type Safety**: Retrofit provides compile-time type checking for API endpoints
2. **Automatic Serialization**: JSON data is automatically converted to Dart objects
3. **Centralized Error Handling**: All errors are handled consistently
4. **Easy Testing**: Repository layer makes it easy to mock API calls
5. **Reactive UI**: Riverpod automatically rebuilds UI when data changes
6. **Immutable Models**: Freezed ensures data integrity
7. **Automatic Token Management**: Interceptor adds auth tokens automatically
8. **Comprehensive Logging**: All API calls are logged for debugging

## Common Tasks

### Adding a New Endpoint

1. Add method to `cricket_api_client.dart`:
```dart
@GET('cricketapi/series')
Future<SeriesResponseModel> getSeries({
  @Query('apikey') required String apiKey,
});
```

2. Add method to `cricket_repository.dart`:
```dart
Future<SeriesResponseModel> getSeries() async {
  return await _apiClient.getSeries(apiKey: _apiKey);
}
```

3. Run build_runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Creating a New Model

1. Create model file with Freezed:
```dart
@freezed
class NewModel with _$NewModel {
  const factory NewModel({
    required String field1,
    required int field2,
  }) = _NewModel;

  factory NewModel.fromJson(Map<String, dynamic> json) =>
      _$NewModelFromJson(json);
}
```

2. Run build_runner to generate code

### Refreshing Data

```dart
// In your widget
ref.read(matchesNotifierProvider.notifier).refresh();
```

### Changing Filters

```dart
ref.read(matchesNotifierProvider.notifier)
  .changeFilter(MatchFilterType.live);
```

## Troubleshooting

### Build Errors

If you see errors about missing generated files:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### API Not Working

1. Check internet connection
2. Verify API key is correct
3. Check base URL is correct
4. Look at console logs from `CustomLoggerInterceptor`
5. Check if API has rate limits

### State Not Updating

1. Make sure you're using `ref.watch` not `ref.read` in build method
2. Verify the provider is being invalidated correctly
3. Check that mutations call `ref.invalidateSelf()` or update `state`

## Additional Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [Retrofit Documentation](https://pub.dev/packages/retrofit)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Riverpod Documentation](https://riverpod.dev/)
- [JSON Serializable Documentation](https://pub.dev/packages/json_serializable)
