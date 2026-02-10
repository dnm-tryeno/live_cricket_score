// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchModelImpl _$$MatchModelImplFromJson(Map<String, dynamic> json) =>
    _$MatchModelImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      matchType: json['matchType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      date: json['date'] as String? ?? '',
      dateTimeGMT: json['dateTimeGMT'] as String? ?? '',
      teams:
          (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      teamInfo:
          (json['teamInfo'] as List<dynamic>?)
              ?.map((e) => TeamInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      score:
          (json['score'] as List<dynamic>?)
              ?.map((e) => ScoreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      seriesId: json['series_id'] as String? ?? '',
      fantasyEnabled: json['fantasyEnabled'] as bool? ?? false,
      bbbEnabled: json['bbbEnabled'] as bool? ?? false,
      hasSquad: json['hasSquad'] as bool? ?? false,
      matchStarted: json['matchStarted'] as bool? ?? false,
      matchEnded: json['matchEnded'] as bool? ?? false,
      players:
          (json['players'] as List<dynamic>?)
              ?.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MatchModelImplToJson(_$MatchModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'matchType': instance.matchType,
      'status': instance.status,
      'venue': instance.venue,
      'date': instance.date,
      'dateTimeGMT': instance.dateTimeGMT,
      'teams': instance.teams,
      'teamInfo': instance.teamInfo.map((e) => e.toJson()).toList(),
      'score': instance.score.map((e) => e.toJson()).toList(),
      'series_id': instance.seriesId,
      'fantasyEnabled': instance.fantasyEnabled,
      'bbbEnabled': instance.bbbEnabled,
      'hasSquad': instance.hasSquad,
      'matchStarted': instance.matchStarted,
      'matchEnded': instance.matchEnded,
      'players': instance.players.map((e) => e.toJson()).toList(),
    };
