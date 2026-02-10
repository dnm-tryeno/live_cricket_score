import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

/// Model for player batting statistics
@freezed
class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    @Default('') String name,
    @Default(0) int runs,
    @Default(0) int balls,
    @Default(0) int fours,
    @Default(0) int sixes,
    @Default(0.0) double strikeRate,
    @Default(false) bool isOut,
    @Default('') String dismissalType, // "not out", "b", "lbw", "c", "st", etc.
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
