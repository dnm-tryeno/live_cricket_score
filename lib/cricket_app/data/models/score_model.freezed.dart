// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScoreModel _$ScoreModelFromJson(Map<String, dynamic> json) {
  return _ScoreModel.fromJson(json);
}

/// @nodoc
mixin _$ScoreModel {
  int get r => throw _privateConstructorUsedError; // runs
  int get w => throw _privateConstructorUsedError; // wickets
  double get o => throw _privateConstructorUsedError; // overs
  String get inning => throw _privateConstructorUsedError;

  /// Serializes this ScoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreModelCopyWith<ScoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreModelCopyWith<$Res> {
  factory $ScoreModelCopyWith(
    ScoreModel value,
    $Res Function(ScoreModel) then,
  ) = _$ScoreModelCopyWithImpl<$Res, ScoreModel>;
  @useResult
  $Res call({int r, int w, double o, String inning});
}

/// @nodoc
class _$ScoreModelCopyWithImpl<$Res, $Val extends ScoreModel>
    implements $ScoreModelCopyWith<$Res> {
  _$ScoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? r = null,
    Object? w = null,
    Object? o = null,
    Object? inning = null,
  }) {
    return _then(
      _value.copyWith(
            r: null == r
                ? _value.r
                : r // ignore: cast_nullable_to_non_nullable
                      as int,
            w: null == w
                ? _value.w
                : w // ignore: cast_nullable_to_non_nullable
                      as int,
            o: null == o
                ? _value.o
                : o // ignore: cast_nullable_to_non_nullable
                      as double,
            inning: null == inning
                ? _value.inning
                : inning // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScoreModelImplCopyWith<$Res>
    implements $ScoreModelCopyWith<$Res> {
  factory _$$ScoreModelImplCopyWith(
    _$ScoreModelImpl value,
    $Res Function(_$ScoreModelImpl) then,
  ) = __$$ScoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int r, int w, double o, String inning});
}

/// @nodoc
class __$$ScoreModelImplCopyWithImpl<$Res>
    extends _$ScoreModelCopyWithImpl<$Res, _$ScoreModelImpl>
    implements _$$ScoreModelImplCopyWith<$Res> {
  __$$ScoreModelImplCopyWithImpl(
    _$ScoreModelImpl _value,
    $Res Function(_$ScoreModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? r = null,
    Object? w = null,
    Object? o = null,
    Object? inning = null,
  }) {
    return _then(
      _$ScoreModelImpl(
        r: null == r
            ? _value.r
            : r // ignore: cast_nullable_to_non_nullable
                  as int,
        w: null == w
            ? _value.w
            : w // ignore: cast_nullable_to_non_nullable
                  as int,
        o: null == o
            ? _value.o
            : o // ignore: cast_nullable_to_non_nullable
                  as double,
        inning: null == inning
            ? _value.inning
            : inning // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScoreModelImpl implements _ScoreModel {
  const _$ScoreModelImpl({
    this.r = 0,
    this.w = 0,
    this.o = 0.0,
    this.inning = '',
  });

  factory _$ScoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreModelImplFromJson(json);

  @override
  @JsonKey()
  final int r;
  // runs
  @override
  @JsonKey()
  final int w;
  // wickets
  @override
  @JsonKey()
  final double o;
  // overs
  @override
  @JsonKey()
  final String inning;

  @override
  String toString() {
    return 'ScoreModel(r: $r, w: $w, o: $o, inning: $inning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreModelImpl &&
            (identical(other.r, r) || other.r == r) &&
            (identical(other.w, w) || other.w == w) &&
            (identical(other.o, o) || other.o == o) &&
            (identical(other.inning, inning) || other.inning == inning));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, r, w, o, inning);

  /// Create a copy of ScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreModelImplCopyWith<_$ScoreModelImpl> get copyWith =>
      __$$ScoreModelImplCopyWithImpl<_$ScoreModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreModelImplToJson(this);
  }
}

abstract class _ScoreModel implements ScoreModel {
  const factory _ScoreModel({
    final int r,
    final int w,
    final double o,
    final String inning,
  }) = _$ScoreModelImpl;

  factory _ScoreModel.fromJson(Map<String, dynamic> json) =
      _$ScoreModelImpl.fromJson;

  @override
  int get r; // runs
  @override
  int get w; // wickets
  @override
  double get o; // overs
  @override
  String get inning;

  /// Create a copy of ScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreModelImplCopyWith<_$ScoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
