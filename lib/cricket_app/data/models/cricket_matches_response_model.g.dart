// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cricket_matches_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CricketMatchesResponseModelImpl _$$CricketMatchesResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$CricketMatchesResponseModelImpl(
  apikey: json['apikey'] as String?,
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  status: json['status'] as String?,
  reason: json['reason'] as String?,
  info: json['info'] == null
      ? null
      : ApiInfoModel.fromJson(json['info'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CricketMatchesResponseModelImplToJson(
  _$CricketMatchesResponseModelImpl instance,
) => <String, dynamic>{
  'apikey': instance.apikey,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'status': instance.status,
  'reason': instance.reason,
  'info': instance.info?.toJson(),
};
