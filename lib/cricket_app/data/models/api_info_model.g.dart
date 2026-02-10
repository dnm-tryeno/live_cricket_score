// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiInfoModelImpl _$$ApiInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$ApiInfoModelImpl(
      hitsToday: (json['hitsToday'] as num?)?.toInt() ?? 0,
      hitsUsed: (json['hitsUsed'] as num?)?.toInt() ?? 0,
      hitsLimit: (json['hitsLimit'] as num?)?.toInt() ?? 0,
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      server: (json['server'] as num?)?.toInt() ?? 0,
      offsetRows: (json['offsetRows'] as num?)?.toInt() ?? 0,
      totalRows: (json['totalRows'] as num?)?.toInt() ?? 0,
      queryTime: (json['queryTime'] as num?)?.toDouble() ?? 0.0,
      s: (json['s'] as num?)?.toInt() ?? 0,
      cache: (json['cache'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ApiInfoModelImplToJson(_$ApiInfoModelImpl instance) =>
    <String, dynamic>{
      'hitsToday': instance.hitsToday,
      'hitsUsed': instance.hitsUsed,
      'hitsLimit': instance.hitsLimit,
      'credits': instance.credits,
      'server': instance.server,
      'offsetRows': instance.offsetRows,
      'totalRows': instance.totalRows,
      'queryTime': instance.queryTime,
      's': instance.s,
      'cache': instance.cache,
    };
