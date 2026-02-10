// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return _PlayerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerModel {
  String get name => throw _privateConstructorUsedError;
  int get runs => throw _privateConstructorUsedError;
  int get balls => throw _privateConstructorUsedError;
  int get fours => throw _privateConstructorUsedError;
  int get sixes => throw _privateConstructorUsedError;
  double get strikeRate => throw _privateConstructorUsedError;
  bool get isOut => throw _privateConstructorUsedError;
  String get dismissalType => throw _privateConstructorUsedError;

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
    PlayerModel value,
    $Res Function(PlayerModel) then,
  ) = _$PlayerModelCopyWithImpl<$Res, PlayerModel>;
  @useResult
  $Res call({
    String name,
    int runs,
    int balls,
    int fours,
    int sixes,
    double strikeRate,
    bool isOut,
    String dismissalType,
  });
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res, $Val extends PlayerModel>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? runs = null,
    Object? balls = null,
    Object? fours = null,
    Object? sixes = null,
    Object? strikeRate = null,
    Object? isOut = null,
    Object? dismissalType = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            runs: null == runs
                ? _value.runs
                : runs // ignore: cast_nullable_to_non_nullable
                      as int,
            balls: null == balls
                ? _value.balls
                : balls // ignore: cast_nullable_to_non_nullable
                      as int,
            fours: null == fours
                ? _value.fours
                : fours // ignore: cast_nullable_to_non_nullable
                      as int,
            sixes: null == sixes
                ? _value.sixes
                : sixes // ignore: cast_nullable_to_non_nullable
                      as int,
            strikeRate: null == strikeRate
                ? _value.strikeRate
                : strikeRate // ignore: cast_nullable_to_non_nullable
                      as double,
            isOut: null == isOut
                ? _value.isOut
                : isOut // ignore: cast_nullable_to_non_nullable
                      as bool,
            dismissalType: null == dismissalType
                ? _value.dismissalType
                : dismissalType // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerModelImplCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$$PlayerModelImplCopyWith(
    _$PlayerModelImpl value,
    $Res Function(_$PlayerModelImpl) then,
  ) = __$$PlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    int runs,
    int balls,
    int fours,
    int sixes,
    double strikeRate,
    bool isOut,
    String dismissalType,
  });
}

/// @nodoc
class __$$PlayerModelImplCopyWithImpl<$Res>
    extends _$PlayerModelCopyWithImpl<$Res, _$PlayerModelImpl>
    implements _$$PlayerModelImplCopyWith<$Res> {
  __$$PlayerModelImplCopyWithImpl(
    _$PlayerModelImpl _value,
    $Res Function(_$PlayerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? runs = null,
    Object? balls = null,
    Object? fours = null,
    Object? sixes = null,
    Object? strikeRate = null,
    Object? isOut = null,
    Object? dismissalType = null,
  }) {
    return _then(
      _$PlayerModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        runs: null == runs
            ? _value.runs
            : runs // ignore: cast_nullable_to_non_nullable
                  as int,
        balls: null == balls
            ? _value.balls
            : balls // ignore: cast_nullable_to_non_nullable
                  as int,
        fours: null == fours
            ? _value.fours
            : fours // ignore: cast_nullable_to_non_nullable
                  as int,
        sixes: null == sixes
            ? _value.sixes
            : sixes // ignore: cast_nullable_to_non_nullable
                  as int,
        strikeRate: null == strikeRate
            ? _value.strikeRate
            : strikeRate // ignore: cast_nullable_to_non_nullable
                  as double,
        isOut: null == isOut
            ? _value.isOut
            : isOut // ignore: cast_nullable_to_non_nullable
                  as bool,
        dismissalType: null == dismissalType
            ? _value.dismissalType
            : dismissalType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerModelImpl implements _PlayerModel {
  const _$PlayerModelImpl({
    this.name = '',
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.strikeRate = 0.0,
    this.isOut = false,
    this.dismissalType = '',
  });

  factory _$PlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerModelImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int runs;
  @override
  @JsonKey()
  final int balls;
  @override
  @JsonKey()
  final int fours;
  @override
  @JsonKey()
  final int sixes;
  @override
  @JsonKey()
  final double strikeRate;
  @override
  @JsonKey()
  final bool isOut;
  @override
  @JsonKey()
  final String dismissalType;

  @override
  String toString() {
    return 'PlayerModel(name: $name, runs: $runs, balls: $balls, fours: $fours, sixes: $sixes, strikeRate: $strikeRate, isOut: $isOut, dismissalType: $dismissalType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.runs, runs) || other.runs == runs) &&
            (identical(other.balls, balls) || other.balls == balls) &&
            (identical(other.fours, fours) || other.fours == fours) &&
            (identical(other.sixes, sixes) || other.sixes == sixes) &&
            (identical(other.strikeRate, strikeRate) ||
                other.strikeRate == strikeRate) &&
            (identical(other.isOut, isOut) || other.isOut == isOut) &&
            (identical(other.dismissalType, dismissalType) ||
                other.dismissalType == dismissalType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    runs,
    balls,
    fours,
    sixes,
    strikeRate,
    isOut,
    dismissalType,
  );

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      __$$PlayerModelImplCopyWithImpl<_$PlayerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerModelImplToJson(this);
  }
}

abstract class _PlayerModel implements PlayerModel {
  const factory _PlayerModel({
    final String name,
    final int runs,
    final int balls,
    final int fours,
    final int sixes,
    final double strikeRate,
    final bool isOut,
    final String dismissalType,
  }) = _$PlayerModelImpl;

  factory _PlayerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerModelImpl.fromJson;

  @override
  String get name;
  @override
  int get runs;
  @override
  int get balls;
  @override
  int get fours;
  @override
  int get sixes;
  @override
  double get strikeRate;
  @override
  bool get isOut;
  @override
  String get dismissalType;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
