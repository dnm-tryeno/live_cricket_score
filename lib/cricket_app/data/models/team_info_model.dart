import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_info_model.freezed.dart';
part 'team_info_model.g.dart';

/// Model for team information in a cricket match
@freezed
class TeamInfoModel with _$TeamInfoModel {
  const factory TeamInfoModel({
    @Default('') String name,
    String? shortname,
    @Default('') String img,
  }) = _TeamInfoModel;

  factory TeamInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TeamInfoModelFromJson(json);
}
