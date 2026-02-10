import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_model.freezed.dart';
part 'score_model.g.dart';

/// Model for cricket match score (innings)
@freezed
class ScoreModel with _$ScoreModel {
  const factory ScoreModel({
    @Default(0) int r, // runs
    @Default(0) int w, // wickets
    @Default(0.0) double o, // overs
    @Default('') String inning, // inning name
  }) = _ScoreModel;

  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreModelFromJson(json);
}
