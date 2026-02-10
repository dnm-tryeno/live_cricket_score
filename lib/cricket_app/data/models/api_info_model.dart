import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_info_model.freezed.dart';
part 'api_info_model.g.dart';

/// Model for API usage information
@freezed
class ApiInfoModel with _$ApiInfoModel {
  const factory ApiInfoModel({
    @Default(0) int hitsToday,
    @Default(0) int hitsUsed,
    @Default(0) int hitsLimit,
    @Default(0) int credits,
    @Default(0) int server,
    @Default(0) int offsetRows,
    @Default(0) int totalRows,
    @Default(0.0) double queryTime,
    @Default(0) int s,
    @Default(0) int cache,
  }) = _ApiInfoModel;

  factory ApiInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ApiInfoModelFromJson(json);
}
