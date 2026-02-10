// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamInfoModelImpl _$$TeamInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$TeamInfoModelImpl(
      name: json['name'] as String? ?? '',
      shortname: json['shortname'] as String?,
      img: json['img'] as String? ?? '',
    );

Map<String, dynamic> _$$TeamInfoModelImplToJson(_$TeamInfoModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'shortname': instance.shortname,
      'img': instance.img,
    };
