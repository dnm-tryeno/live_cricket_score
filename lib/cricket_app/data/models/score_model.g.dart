// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreModelImpl _$$ScoreModelImplFromJson(Map<String, dynamic> json) =>
    _$ScoreModelImpl(
      r: (json['r'] as num?)?.toInt() ?? 0,
      w: (json['w'] as num?)?.toInt() ?? 0,
      o: (json['o'] as num?)?.toDouble() ?? 0.0,
      inning: json['inning'] as String? ?? '',
    );

Map<String, dynamic> _$$ScoreModelImplToJson(_$ScoreModelImpl instance) =>
    <String, dynamic>{
      'r': instance.r,
      'w': instance.w,
      'o': instance.o,
      'inning': instance.inning,
    };
