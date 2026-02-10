# Cricket App

A complete cricket app UI/UX implementation with onboarding flow, home screen, match center, and team selection features.

## Structure

```
cricket_app/
├── constants/
│   ├── cricket_colors.dart      # Color constants
│   ├── cricket_strings.dart      # String constants
│   └── cricket_text_styles.dart  # Text style constants
├── screens/
│   ├── onboarding/
│   │   ├── onboarding_screen_1.dart  # "Live Cricket Scores. Anytime."
│   │   ├── onboarding_screen_2.dart  # "Fastest Ball-by-Ball Updates"
│   │   ├── onboarding_screen_3.dart  # "Follow Your Favorites"
│   │   └── onboarding_flow.dart     # Onboarding flow manager
│   ├── home/
│   │   └── cricket_home_screen.dart  # Main home screen
│   └── match_center/
│       └── match_center_screen.dart  # Live match details & commentary
├── widgets/
│   ├── ball_indicator.dart       # Ball outcome indicator
│   ├── live_indicator.dart       # Live match indicator
│   ├── page_indicator.dart       # Onboarding page dots
│   ├── primary_button.dart       # Primary action button
│   └── team_badge.dart           # Team badge widget
├── cricket_app.dart              # Main app entry widget
└── README.md                     # This file
```

## Code generation (cricket app-style)

API calling follows the same pattern as cricket app: **client → repository → Riverpod provider**. All generated files (`.freezed.dart`, `.g.dart`) are produced by **build_runner** — **do not create them manually**.

After changing models or providers, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

- **Freezed**: `@freezed` + `part 'x.freezed.dart'` + `part 'x.g.dart'` in `data/models/`
- **Riverpod**: `@riverpod` + `part 'x.g.dart'` in providers and `data/remote/api_client/providers/`, `data/repositories/providers/`

## How to Run

### Option 1: Using Cricket Main (Recommended)
Use the dedicated cricket main file:
```dart
// In your IDE, set entry point to:
lib/main/cricket_main.dart
```

### Option 2: Using Shared Main
Modify `lib/main/shared_main.dart`:
```dart
// Change this line:
const bool launchCricketApp = false;
// To:
const bool launchCricketApp = true;
```

## Features

### Onboarding Screens
1. **Screen 1**: Introduction with live match preview
2. **Screen 2**: Ball-by-ball updates feature showcase
3. **Screen 3**: Team and league selection

### Home Screen
- Featured matches with live indicators
- Series coverage cards
- Match filters (Live, Upcoming, Finished)
- Bottom navigation

### Match Center
- Live match scores and statistics
- Recent balls indicator
- Commentary feed
- Match tabs (Batting, Bowling, Commentary, Lineups)
- Predictions button

## Design System

### Colors
- **Primary Green**: `#00FF88` - Main accent color
- **Accent Red**: `#FF0000` - For wickets, live indicators
- **Dark Green**: `#0A1F0A` - Background color
- **Background Dark**: `#111111` - Main dark background

### Typography
- Headlines: Bold, large sizes (32px, 24px, 20px)
- Body: Regular weight (16px, 14px, 12px)
- Scores: Extra bold, large sizes (36px, 28px)

## Navigation Flow

```
OnboardingFlow
  ├── OnboardingScreen1 → OnboardingScreen2
  ├── OnboardingScreen2 → OnboardingScreen3
  └── OnboardingScreen3 → CricketHomeScreen
        └── CricketHomeScreen → MatchCenterScreen
```

## Customization

All colors, text styles, and strings are centralized in the `constants/` folder for easy customization.
