# Cricket App API Setup - Quick Start

## What Was Implemented

I've implemented a complete API calling architecture for your cricket app, following the same pattern as the cricket app app. This includes:

✅ **Error Handling Infrastructure**
- Custom error types and exceptions
- Automatic error conversion from Dio to typed exceptions
- User-friendly error messages

✅ **Data Models**
- Freezed models for immutability
- JSON serialization support
- Models for: Match, TeamInfo, Score, ApiInfo, and CricketMatchesResponse

✅ **API Client Layer**
- Retrofit-based API client
- Dio HTTP client with interceptors
- Custom logging interceptor (logs requests/responses)
- Error interceptor (automatic error handling)
- Authentication token management

✅ **Repository Layer**
- Clean data access abstraction
- Methods for: getAllMatches, getLiveMatches, getUpcomingMatches, getFinishedMatches, etc.

✅ **State Management**
- Riverpod AsyncNotifier for reactive state
- Automatic loading/error/data states
- Filter management (all/live/upcoming/finished)
- Caching support

✅ **Utilities**
- Error handler util for displaying errors in UI
- Comprehensive documentation

## Next Steps

### 1. Install Dependencies

```bash
cd /Users/dinanathmaurya/Documents/GitHub/ai-background-remover/mobile
flutter pub get
```

### 2. Generate Code

Run build_runner to generate all necessary files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate approximately 15+ files:
- `.freezed.dart` files for models (5 files)
- `.g.dart` files for JSON serialization (5 files)
- `.g.dart` for API client (1 file)
- `.g.dart` for providers (3 files)

### 3. Configure API Key

Open: `lib/cricket_app/data/remote/api_client/providers/cricket_api_client_provider.dart`

Update line 34 with your API key:
```dart
@riverpod
String cricketApiKey(CricketApiKeyRef ref) {
  return 'YOUR_API_KEY_HERE'; // Replace with actual key
}
```

### 4. Verify Base URL

In the same file, verify the base URL (line 29):
```dart
const baseUrl = 'https://api.cricapi.com/v1/';
```

### 5. Use in Your Screens

See the comprehensive examples in:
`lib/cricket_app/API_INTEGRATION_GUIDE.md`

Quick example:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'providers/matches_provider.dart';

class MyMatchesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchesNotifierProvider);

    return matchesAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (response) => ListView.builder(
        itemCount: response.data.length,
        itemBuilder: (context, index) {
          final match = response.data[index];
          return ListTile(
            title: Text(match.name),
            subtitle: Text(match.status),
          );
        },
      ),
    );
  }
}
```

## File Structure Created

```
lib/cricket_app/
├── data/
│   ├── models/                                    # 5 model files
│   │   ├── team_info_model.dart
│   │   ├── score_model.dart
│   │   ├── match_model.dart
│   │   ├── api_info_model.dart
│   │   └── cricket_matches_response_model.dart
│   ├── remote/
│   │   ├── api_client/
│   │   │   ├── cricket_api_client.dart            # API endpoints
│   │   │   ├── custom_log_interceptor.dart        # Logging
│   │   │   └── providers/
│   │   │       └── cricket_api_client_provider.dart
│   │   └── api_error_handling/                    # 7 error handling files
│   │       ├── model/
│   │       │   ├── error_type.dart
│   │       │   ├── error_messages.dart
│   │       │   ├── error_info.dart
│   │       │   └── api_error_model.dart
│   │       ├── exceptions/
│   │       │   └── api_exceptions.dart
│   │       ├── error_interceptor.dart
│   │       └── interceptor_error_handler.dart
│   └── repositories/
│       ├── cricket_repository.dart
│       └── providers/
│           └── cricket_repository_provider.dart
├── providers/
│   └── matches_provider.dart                      # State management
├── utils/
│   └── error_handler_util.dart                    # UI error handling
└── API_INTEGRATION_GUIDE.md                       # Full documentation
```

**Total Files Created: ~20 files**

## Architecture Flow

```
Screen (UI)
    ↓
ref.watch(matchesNotifierProvider)
    ↓
MatchesNotifier (State Management)
    ↓
CricketRepository (Data Layer)
    ↓
CricketApiClient (Retrofit)
    ↓
Interceptors (Auth + Error + Logging)
    ↓
Dio (HTTP Client)
    ↓
API Call → Response → Model → State Update → UI Rebuild
```

## Key Features

1. **Type-Safe API Calls**: Retrofit ensures compile-time type checking
2. **Automatic Error Handling**: All errors are caught and converted to user-friendly messages
3. **Reactive UI**: Riverpod automatically rebuilds UI when data changes
4. **Request Logging**: See all requests/responses in console for debugging
5. **Immutable Models**: Freezed prevents accidental data mutation
6. **Centralized Configuration**: API key and base URL in one place
7. **Easy Testing**: Repository pattern makes mocking simple

## Testing the API

After running build_runner, test the API:

```dart
// Add this button in any screen to test
ElevatedButton(
  onPressed: () async {
    try {
      final repo = ref.read(cricketRepositoryProvider);
      final response = await repo.getAllMatches();
      print('✅ Success: ${response.data.length} matches');
    } catch (e) {
      print('❌ Error: $e');
    }
  },
  child: Text('Test API'),
)
```

## Console Output Example

When you make an API call, you'll see:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌐 API REQUEST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
URL: https://api.cricapi.com/v1/cricketapi
METHOD: GET
QUERY PARAMS: {apikey: xxx, status: live}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ API RESPONSE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STATUS CODE: 200
RESPONSE BODY: {"apikey":"xxx","data":[...],"status":"success"}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Troubleshooting

### "Missing generated files" error

Run:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### API returns error

1. Check API key is correct
2. Verify base URL
3. Check your internet connection
4. Look at console logs from CustomLoggerInterceptor

### State not updating

Make sure you're using `ref.watch` in build method, not `ref.read`.

## Dependencies Added

```yaml
dependencies:
  dio: ^5.4.0                    # HTTP client
  retrofit: ^4.0.0               # API client generator
  json_annotation: ^4.8.1        # JSON serialization
  freezed_annotation: ^2.4.1     # Immutable models

dev_dependencies:
  retrofit_generator: ^8.0.0     # Generates API client
  json_serializable: ^6.7.1      # Generates JSON code
  freezed: ^2.4.6                # Generates freezed classes
  build_runner: ^2.3.3           # Runs code generators
```

## Support

For detailed documentation and examples, see:
- `lib/cricket_app/API_INTEGRATION_GUIDE.md`

For questions about the implementation pattern, refer to the cricket app app at:
- `/Users/dinanathmaurya/Documents/GitHub/cricket app/mobile`

---

**Created by:** Claude Code
**Date:** 2026-01-27
**Based on:** cricket app app API architecture pattern
