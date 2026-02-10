# Cricket API Data Mapping Guide

This guide shows exactly which API response fields to use in your UI.

## API Endpoint

**URL:** `https://api.cricapi.com/v1/currentMatches?apikey=YOUR_KEY&offset=0`

**Returns:** List of current cricket matches (live, upcoming, finished)

---

## Data Fields to Display

### 1. Match Card Header

```json
{
  "matchStarted": true,     // ✅ Show "LIVE" badge if true AND matchEnded=false
  "matchEnded": false,      // ✅ Hide from live tab if true
  "matchType": "test"       // ✅ Display as badge (TEST/T20/ODI/T10)
}
```

**UI Display:**
- 🔴 **LIVE** badge (red) - Show if `matchStarted=true` AND `matchEnded=false`
- **TEST/T20/ODI** badge (green) - From `matchType` field

---

### 2. Match Title

```json
{
  "name": "Border vs Knights, 18th Match, CSA Four-Day Series Division Two 2025-26"
}
```

**UI Display:**
- Full match name
- Truncate to 2 lines if too long

---

### 3. Team Information

```json
{
  "teams": ["Border", "Knights"],           // Team names array
  "teamInfo": [
    {
      "name": "Border",                     // ✅ Full team name
      "shortname": "BR",                    // ✅ Use for compact display
      "img": "https://..."                  // ✅ Team logo URL
    },
    {
      "name": "Knights",
      "shortname": "KNG",
      "img": "https://..."
    }
  ]
}
```

**UI Display:**
- Team logo (32x32 circular image)
- Team shortname or name
- Layout: `[Logo] Team Name    Score`

**Important Notes:**
- Use `teamInfo[0]` for first team
- Use `teamInfo[1]` for second team
- Fallback to first letter of shortname if image fails to load
- Some teams may not have `shortname` - use `name` as fallback

---

### 4. Match Scores

```json
{
  "score": [
    {
      "r": 326,                            // ✅ Runs
      "w": 10,                             // ✅ Wickets
      "o": 109,                            // ✅ Overs (can be decimal like 71.3)
      "inning": "Knights Inning 1"         // ✅ Inning name
    },
    {
      "r": 142,
      "w": 10,
      "o": 71.3,
      "inning": "Border Inning 1"
    },
    {
      "r": 174,
      "w": 5,
      "o": 39,
      "inning": "Knights Inning 2"
    },
    {
      "r": 129,
      "w": 3,
      "o": 48,
      "inning": "Border Inning 2"
    }
  ]
}
```

**UI Display Format:**
```
326/10 (109 ov)
```

**Display Logic:**
- For **Live Matches**: Show latest 2 innings (most recent scores)
- For **Test Matches**: May have 4 innings, show latest 2
- For **T20/ODI**: Usually 1-2 innings
- Format: `{runs}/{wickets} ({overs} ov)`

**Code Example:**
```dart
// Get latest 2 innings
final displayScores = match.score.length > 2
    ? match.score.sublist(match.score.length - 2)
    : match.score;

// Display format
String scoreText = '${score.r}/${score.w} (${score.o} ov)';
```

---

### 5. Match Status

```json
{
  "status": "Day 3: Stumps - Border need 230 runs"
}
```

**UI Display:**
- Show below team scores
- Color: Green (`CricketColors.primaryGreen`)
- Font size: 12px
- Examples:
  - "Day 3: Stumps - Border need 230 runs"
  - "Rain stops play - Canterbury opt to bowl"
  - "Match starts at 08:00 GMT"
  - "India won by 7 wickets"

---

### 6. Venue & Date

```json
{
  "venue": "Buffalo Park, East London",    // ✅ Stadium name and location
  "date": "2026-01-22",                     // ✅ Date in YYYY-MM-DD format
  "dateTimeGMT": "2026-01-22T08:00:00"     // ✅ Exact start time (GMT)
}
```

**UI Display:**
- Venue: Show with location pin icon 📍
- Date: Format as needed (e.g., "Jan 22, 2026")
- For live matches: Venue is more important than date

---

### 7. Additional Useful Fields

```json
{
  "id": "6e09556e-0270-405d-8050-f1323fe5df4e",      // ✅ Unique match ID
  "series_id": "e7a279a7-a04b-4b47-8e70-551ccf3e620d", // ✅ Series/tournament ID
  "fantasyEnabled": true,     // Can show fantasy points if true
  "bbbEnabled": false,        // Ball-by-ball commentary available
  "hasSquad": false          // Squad/player list available
}
```

**Usage:**
- `id`: Use for navigation to match details page
- `series_id`: Use to group matches by series
- `fantasyEnabled`: Show fantasy icon/badge
- `bbbEnabled`: Show "Live Commentary" badge
- `hasSquad`: Show "View Squad" button

---

## Live Matches Tab - Filtering Logic

### Filter Criteria

```dart
// Show only matches where:
final liveMatches = allMatches.where((match) =>
  match.matchStarted == true &&     // Match has started
  match.matchEnded == false         // Match has NOT ended
).toList();
```

### Sort Order (Optional)

```dart
// Sort by most recent first
liveMatches.sort((a, b) =>
  b.dateTimeGMT.compareTo(a.dateTimeGMT)
);
```

---

## Complete Match Card Layout

```
┌───────────────────────────────────────────────────────┐
│ 🔴 LIVE    TEST                          [⋮]          │
├───────────────────────────────────────────────────────┤
│ Border vs Knights, 18th Match                         │
│ CSA Four-Day Series Division Two 2025-26              │
├───────────────────────────────────────────────────────┤
│  [BR]  Border                    326/10 (109 ov)      │
│  [KNG] Knights                   142/10 (71.3 ov)     │
├───────────────────────────────────────────────────────┤
│ 📍 Buffalo Park, East London                          │
│ Day 3: Stumps - Border need 230 runs                  │
└───────────────────────────────────────────────────────┘
```

### Element Breakdown:

1. **Header Row:**
   - 🔴 LIVE badge (conditional)
   - TEST badge
   - More menu (⋮)

2. **Title Row:**
   - Full match name (2 lines max)

3. **Teams Row (× 2):**
   - Team logo (32×32px circle)
   - Team name/shortname
   - Score (runs/wickets/overs)

4. **Footer Row:**
   - Venue with location icon
   - Match status

---

## Color Scheme

```dart
// From cricket_colors.dart
CricketColors.primaryGreen     // #00FF88 - Scores, badges
CricketColors.accentRed        // #F24747 - Live indicator
CricketColors.textWhite        // #FFFFFF - Primary text
CricketColors.textGrey         // #999999 - Secondary text
CricketColors.backgroundDark   // #111111 - Screen background
CricketColors.cardBackground   // #1A1A1A - Card background
```

---

## API Response Structure

```json
{
  "apikey": "a6a09259-8111-49e7-b30d-f9d307d79cad",
  "data": [
    {
      // ... match object (shown above)
    }
  ],
  "status": "success",
  "info": {
    "hitsToday": 2,
    "hitsUsed": 1,
    "hitsLimit": 100,
    "credits": 0,
    "server": 18,
    "offsetRows": 0,
    "totalRows": 15,
    "queryTime": 37.2126,
    "s": 0,
    "cache": 0
  }
}
```

**Top Level Fields:**
- `data[]`: Array of match objects ✅ **Use this**
- `status`: "success" or "error"
- `info`: API usage metadata (not needed for UI)

---

## Implementation Checklist

- [x] Create models for API response
- [x] Create `LiveMatchCard` widget
- [x] Create `LiveMatchesExample` screen
- [x] Filter matches by `matchStarted && !matchEnded`
- [x] Display team logos with fallback
- [x] Format scores as `r/w (o ov)`
- [x] Show live indicator badge
- [x] Show match type badge
- [x] Display venue and status
- [x] Handle loading/error states
- [x] Add pull-to-refresh

---

## Next Steps

1. **Run code generation:**
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Test the API:**
   ```bash
   curl "https://api.cricapi.com/v1/currentMatches?apikey=a6a09259-8111-49e7-b30d-f9d307d79cad&offset=0"
   ```

3. **Use in your app:**
   ```dart
   import 'package:flutter/material.dart';
   import 'cricket_app/screens/matches/live_matches_example.dart';

   // In your navigation:
   Navigator.push(
     context,
     MaterialPageRoute(builder: (_) => LiveMatchesExample()),
   );
   ```

---

## Common Issues & Solutions

### Issue: Team logo not loading
**Solution:** Fallback to first letter of shortname
```dart
errorBuilder: (context, error, stackTrace) {
  return Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      color: CricketColors.cardBackgroundLight,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        teamInfo.shortname?.substring(0, 1) ?? 'T',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
```

### Issue: Score array is empty
**Solution:** Check if score exists before displaying
```dart
if (score != null)
  Text('${score.r}/${score.w} (${score.o} ov)')
```

### Issue: No live matches
**Solution:** Show empty state
```dart
if (liveMatches.isEmpty) {
  return Center(
    child: Text('No live matches at the moment'),
  );
}
```

---

## API Endpoints Reference

| Endpoint | Query Params | Returns |
|----------|-------------|---------|
| `/currentMatches` | `apikey`, `offset` | All current matches |
| `/currentMatches` | `apikey`, `offset=0` | First 25 matches |

**Note:** The API doesn't have separate endpoints for live/upcoming/finished. You must filter the `data[]` array based on `matchStarted` and `matchEnded` flags.

---

## Summary

**Essential Fields for Live Matches Tab:**

1. ✅ `matchStarted` && `!matchEnded` - Filter condition
2. ✅ `name` - Match title
3. ✅ `matchType` - Match type badge
4. ✅ `teamInfo[].name` - Team names
5. ✅ `teamInfo[].shortname` - Short names
6. ✅ `teamInfo[].img` - Team logos
7. ✅ `score[].r` - Runs
8. ✅ `score[].w` - Wickets
9. ✅ `score[].o` - Overs
10. ✅ `status` - Match status text
11. ✅ `venue` - Stadium location
12. ✅ `id` - For navigation

**That's it!** These 12 fields are all you need to create a complete live match card UI. 🎯
