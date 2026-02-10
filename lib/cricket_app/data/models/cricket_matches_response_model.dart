import 'package:freezed_annotation/freezed_annotation.dart';
import 'match_model.dart';
import 'api_info_model.dart';

part 'cricket_matches_response_model.freezed.dart';
part 'cricket_matches_response_model.g.dart';

/// Main response model for cricket matches API
@freezed
class CricketMatchesResponseModel with _$CricketMatchesResponseModel {
  const factory CricketMatchesResponseModel({
    String? apikey,
    @Default([]) List<MatchModel> data,
    String? status,
    String? reason,
    ApiInfoModel? info,
  }) = _CricketMatchesResponseModel;

  factory CricketMatchesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CricketMatchesResponseModelFromJson(json);
}
