import 'score_model.dart';
import 'team_info_model.dart';

/// Response model for match_scorecard API
class MatchScorecardResponseModel {
  final String? status;
  final MatchScorecardData? data;

  MatchScorecardResponseModel({this.status, this.data});

  factory MatchScorecardResponseModel.fromJson(Map<String, dynamic> json) {
    return MatchScorecardResponseModel(
      status: json['status'] as String?,
      data: json['data'] != null
          ? MatchScorecardData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Match scorecard data (id, name, score[], scorecard[], etc.)
class MatchScorecardData {
  final String id;
  final String name;
  final String matchType;
  final String status;
  final String venue;
  final String date;
  final String dateTimeGMT;
  final List<String> teams;
  final List<TeamInfoModel> teamInfo;
  final List<ScoreModel> score;
  final List<ScorecardInningModel> scorecard;
  final bool matchStarted;
  final bool matchEnded;

  MatchScorecardData({
    this.id = '',
    this.name = '',
    this.matchType = '',
    this.status = '',
    this.venue = '',
    this.date = '',
    this.dateTimeGMT = '',
    this.teams = const [],
    this.teamInfo = const [],
    this.score = const [],
    this.scorecard = const [],
    this.matchStarted = false,
    this.matchEnded = false,
  });

  factory MatchScorecardData.fromJson(Map<String, dynamic> json) {
    final scoreList = json['score'];
    final scorecardList = json['scorecard'];
    final teamInfoList = json['teamInfo'];

    return MatchScorecardData(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      matchType: (json['matchType'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      venue: (json['venue'] as String?) ?? '',
      date: (json['date'] as String?) ?? '',
      dateTimeGMT: (json['dateTimeGMT'] as String?) ?? '',
      teams:
          (json['teams'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      teamInfo: teamInfoList is List
          ? (teamInfoList)
                .map((e) => TeamInfoModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      score: scoreList is List
          ? (scoreList)
                .map((e) => ScoreModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      scorecard: scorecardList is List
          ? (scorecardList)
                .map(
                  (e) =>
                      ScorecardInningModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      matchStarted: (json['matchStarted'] as bool?) ?? false,
      matchEnded: (json['matchEnded'] as bool?) ?? false,
    );
  }
}

/// One innings in the scorecard (batting + bowling)
class ScorecardInningModel {
  final List<BattingEntryModel> batting;
  final List<BowlingEntryModel> bowling;
  final String inning;
  final ScorecardExtras? extras;

  ScorecardInningModel({
    this.batting = const [],
    this.bowling = const [],
    this.inning = '',
    this.extras,
  });

  factory ScorecardInningModel.fromJson(Map<String, dynamic> json) {
    final battingList = json['batting'];
    final bowlingList = json['bowling'];

    return ScorecardInningModel(
      batting: battingList is List
          ? (battingList)
                .map(
                  (e) => BattingEntryModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      bowling: bowlingList is List
          ? (bowlingList)
                .map(
                  (e) => BowlingEntryModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      inning: (json['inning'] as String?) ?? '',
      extras: json['extras'] != null
          ? ScorecardExtras.fromJson(json['extras'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Batting row: batsman name, dismissal, r, b, 4s, 6s, sr
class BattingEntryModel {
  final PlayerRefModel batsman;
  final String dismissalText;
  final int r;
  final int b;
  final int fours;
  final int sixes;
  final double sr;

  BattingEntryModel({
    required this.batsman,
    this.dismissalText = '',
    this.r = 0,
    this.b = 0,
    this.fours = 0,
    this.sixes = 0,
    this.sr = 0,
  });

  factory BattingEntryModel.fromJson(Map<String, dynamic> json) {
    return BattingEntryModel(
      batsman: json['batsman'] != null
          ? PlayerRefModel.fromJson(json['batsman'] as Map<String, dynamic>)
          : PlayerRefModel(id: '', name: ''),
      dismissalText: (json['dismissal-text'] as String?) ?? '',
      r: (json['r'] is int)
          ? json['r'] as int
          : int.tryParse('${json['r']}') ?? 0,
      b: (json['b'] is int)
          ? json['b'] as int
          : int.tryParse('${json['b']}') ?? 0,
      fours: (json['4s'] is int)
          ? json['4s'] as int
          : int.tryParse('${json['4s']}') ?? 0,
      sixes: (json['6s'] is int)
          ? json['6s'] as int
          : int.tryParse('${json['6s']}') ?? 0,
      sr: (json['sr'] is num)
          ? (json['sr'] as num).toDouble()
          : double.tryParse('${json['sr']}') ?? 0,
    );
  }
}

/// Bowling row: bowler name, o, m, r, w, eco
class BowlingEntryModel {
  final PlayerRefModel bowler;
  final double o;
  final int m;
  final int r;
  final int w;
  final double eco;
  final int nb;
  final int wd;

  BowlingEntryModel({
    required this.bowler,
    this.o = 0,
    this.m = 0,
    this.r = 0,
    this.w = 0,
    this.eco = 0,
    this.nb = 0,
    this.wd = 0,
  });

  factory BowlingEntryModel.fromJson(Map<String, dynamic> json) {
    return BowlingEntryModel(
      bowler: json['bowler'] != null
          ? PlayerRefModel.fromJson(json['bowler'] as Map<String, dynamic>)
          : PlayerRefModel(id: '', name: ''),
      o: (json['o'] is num)
          ? (json['o'] as num).toDouble()
          : double.tryParse('${json['o']}') ?? 0,
      m: (json['m'] is int)
          ? json['m'] as int
          : int.tryParse('${json['m']}') ?? 0,
      r: (json['r'] is int)
          ? json['r'] as int
          : int.tryParse('${json['r']}') ?? 0,
      w: (json['w'] is int)
          ? json['w'] as int
          : int.tryParse('${json['w']}') ?? 0,
      eco: (json['eco'] is num)
          ? (json['eco'] as num).toDouble()
          : double.tryParse('${json['eco']}') ?? 0,
      nb: (json['nb'] is int)
          ? json['nb'] as int
          : int.tryParse('${json['nb']}') ?? 0,
      wd: (json['wd'] is int)
          ? json['wd'] as int
          : int.tryParse('${json['wd']}') ?? 0,
    );
  }
}

/// Player reference (id, name)
class PlayerRefModel {
  final String id;
  final String name;

  PlayerRefModel({this.id = '', this.name = ''});

  factory PlayerRefModel.fromJson(Map<String, dynamic> json) {
    return PlayerRefModel(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
    );
  }
}

/// Extras (r, b)
class ScorecardExtras {
  final int r;
  final int b;

  ScorecardExtras({this.r = 0, this.b = 0});

  factory ScorecardExtras.fromJson(Map<String, dynamic> json) {
    return ScorecardExtras(
      r: (json['r'] is int)
          ? json['r'] as int
          : int.tryParse('${json['r']}') ?? 0,
      b: (json['b'] is int)
          ? json['b'] as int
          : int.tryParse('${json['b']}') ?? 0,
    );
  }
}
