import 'package:freezed_annotation/freezed_annotation.dart';
import 'team_info_model.dart';
import 'score_model.dart';
import 'player_model.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// Model for cricket match data
@freezed
class MatchModel with _$MatchModel {
  const factory MatchModel({
    @Default('') String id,
    @Default('') String name,
    @Default('') String matchType,
    @Default('') String status,
    @Default('') String venue,
    @Default('') String date,
    @Default('') String dateTimeGMT,
    @Default([]) List<String> teams,
    @Default([]) List<TeamInfoModel> teamInfo,
    @Default([]) List<ScoreModel> score,
    @JsonKey(name: 'series_id') @Default('') String seriesId,
    @Default(false) bool fantasyEnabled,
    @Default(false) bool bbbEnabled,
    @Default(false) bool hasSquad,
    @Default(false) bool matchStarted,
    @Default(false) bool matchEnded,
    @Default([]) List<PlayerModel> players, // Player statistics
  }) = _MatchModel;

  factory MatchModel.fromJson(Map<String, dynamic> json) =>
      _$MatchModelFromJson(json);
}
