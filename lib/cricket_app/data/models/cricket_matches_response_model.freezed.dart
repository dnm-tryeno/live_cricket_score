// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cricket_matches_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CricketMatchesResponseModel _$CricketMatchesResponseModelFromJson(
  Map<String, dynamic> json,
) {
  return _CricketMatchesResponseModel.fromJson(json);
}

/// @nodoc
mixin _$CricketMatchesResponseModel {
  String? get apikey => throw _privateConstructorUsedError;
  List<MatchModel> get data => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  ApiInfoModel? get info => throw _privateConstructorUsedError;

  /// Serializes this CricketMatchesResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CricketMatchesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CricketMatchesResponseModelCopyWith<CricketMatchesResponseModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CricketMatchesResponseModelCopyWith<$Res> {
  factory $CricketMatchesResponseModelCopyWith(
    CricketMatchesResponseModel value,
    $Res Function(CricketMatchesResponseModel) then,
  ) =
      _$CricketMatchesResponseModelCopyWithImpl<
        $Res,
        CricketMatchesResponseModel
      >;
  @useResult
  $Res call({
    String? apikey,
    List<MatchModel> data,
    String? status,
    String? reason,
    ApiInfoModel? info,
  });

  $ApiInfoModelCopyWith<$Res>? get info;
}

/// @nodoc
class _$CricketMatchesResponseModelCopyWithImpl<
  $Res,
  $Val extends CricketMatchesResponseModel
>
    implements $CricketMatchesResponseModelCopyWith<$Res> {
  _$CricketMatchesResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CricketMatchesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apikey = freezed,
    Object? data = null,
    Object? status = freezed,
    Object? reason = freezed,
    Object? info = freezed,
  }) {
    return _then(
      _value.copyWith(
            apikey: freezed == apikey
                ? _value.apikey
                : apikey // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<MatchModel>,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
            info: freezed == info
                ? _value.info
                : info // ignore: cast_nullable_to_non_nullable
                      as ApiInfoModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of CricketMatchesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiInfoModelCopyWith<$Res>? get info {
    if (_value.info == null) {
      return null;
    }

    return $ApiInfoModelCopyWith<$Res>(_value.info!, (value) {
      return _then(_value.copyWith(info: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CricketMatchesResponseModelImplCopyWith<$Res>
    implements $CricketMatchesResponseModelCopyWith<$Res> {
  factory _$$CricketMatchesResponseModelImplCopyWith(
    _$CricketMatchesResponseModelImpl value,
    $Res Function(_$CricketMatchesResponseModelImpl) then,
  ) = __$$CricketMatchesResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? apikey,
    List<MatchModel> data,
    String? status,
    String? reason,
    ApiInfoModel? info,
  });

  @override
  $ApiInfoModelCopyWith<$Res>? get info;
}

/// @nodoc
class __$$CricketMatchesResponseModelImplCopyWithImpl<$Res>
    extends
        _$CricketMatchesResponseModelCopyWithImpl<
          $Res,
          _$CricketMatchesResponseModelImpl
        >
    implements _$$CricketMatchesResponseModelImplCopyWith<$Res> {
  __$$CricketMatchesResponseModelImplCopyWithImpl(
    _$CricketMatchesResponseModelImpl _value,
    $Res Function(_$CricketMatchesResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CricketMatchesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apikey = freezed,
    Object? data = null,
    Object? status = freezed,
    Object? reason = freezed,
    Object? info = freezed,
  }) {
    return _then(
      _$CricketMatchesResponseModelImpl(
        apikey: freezed == apikey
            ? _value.apikey
            : apikey // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<MatchModel>,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        info: freezed == info
            ? _value.info
            : info // ignore: cast_nullable_to_non_nullable
                  as ApiInfoModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CricketMatchesResponseModelImpl
    implements _CricketMatchesResponseModel {
  const _$CricketMatchesResponseModelImpl({
    this.apikey,
    final List<MatchModel> data = const [],
    this.status,
    this.reason,
    this.info,
  }) : _data = data;

  factory _$CricketMatchesResponseModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CricketMatchesResponseModelImplFromJson(json);

  @override
  final String? apikey;
  final List<MatchModel> _data;
  @override
  @JsonKey()
  List<MatchModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? status;
  @override
  final String? reason;
  @override
  final ApiInfoModel? info;

  @override
  String toString() {
    return 'CricketMatchesResponseModel(apikey: $apikey, data: $data, status: $status, reason: $reason, info: $info)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CricketMatchesResponseModelImpl &&
            (identical(other.apikey, apikey) || other.apikey == apikey) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.info, info) || other.info == info));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    apikey,
    const DeepCollectionEquality().hash(_data),
    status,
    reason,
    info,
  );

  /// Create a copy of CricketMatchesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CricketMatchesResponseModelImplCopyWith<_$CricketMatchesResponseModelImpl>
  get copyWith =>
      __$$CricketMatchesResponseModelImplCopyWithImpl<
        _$CricketMatchesResponseModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CricketMatchesResponseModelImplToJson(this);
  }
}

abstract class _CricketMatchesResponseModel
    implements CricketMatchesResponseModel {
  const factory _CricketMatchesResponseModel({
    final String? apikey,
    final List<MatchModel> data,
    final String? status,
    final String? reason,
    final ApiInfoModel? info,
  }) = _$CricketMatchesResponseModelImpl;

  factory _CricketMatchesResponseModel.fromJson(Map<String, dynamic> json) =
      _$CricketMatchesResponseModelImpl.fromJson;

  @override
  String? get apikey;
  @override
  List<MatchModel> get data;
  @override
  String? get status;
  @override
  String? get reason;
  @override
  ApiInfoModel? get info;

  /// Create a copy of CricketMatchesResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CricketMatchesResponseModelImplCopyWith<_$CricketMatchesResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
