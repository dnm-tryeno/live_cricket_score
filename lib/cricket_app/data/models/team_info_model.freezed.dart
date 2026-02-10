// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamInfoModel _$TeamInfoModelFromJson(Map<String, dynamic> json) {
  return _TeamInfoModel.fromJson(json);
}

/// @nodoc
mixin _$TeamInfoModel {
  String get name => throw _privateConstructorUsedError;
  String? get shortname => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;

  /// Serializes this TeamInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamInfoModelCopyWith<TeamInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInfoModelCopyWith<$Res> {
  factory $TeamInfoModelCopyWith(
    TeamInfoModel value,
    $Res Function(TeamInfoModel) then,
  ) = _$TeamInfoModelCopyWithImpl<$Res, TeamInfoModel>;
  @useResult
  $Res call({String name, String? shortname, String img});
}

/// @nodoc
class _$TeamInfoModelCopyWithImpl<$Res, $Val extends TeamInfoModel>
    implements $TeamInfoModelCopyWith<$Res> {
  _$TeamInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? shortname = freezed,
    Object? img = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            shortname: freezed == shortname
                ? _value.shortname
                : shortname // ignore: cast_nullable_to_non_nullable
                      as String?,
            img: null == img
                ? _value.img
                : img // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamInfoModelImplCopyWith<$Res>
    implements $TeamInfoModelCopyWith<$Res> {
  factory _$$TeamInfoModelImplCopyWith(
    _$TeamInfoModelImpl value,
    $Res Function(_$TeamInfoModelImpl) then,
  ) = __$$TeamInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? shortname, String img});
}

/// @nodoc
class __$$TeamInfoModelImplCopyWithImpl<$Res>
    extends _$TeamInfoModelCopyWithImpl<$Res, _$TeamInfoModelImpl>
    implements _$$TeamInfoModelImplCopyWith<$Res> {
  __$$TeamInfoModelImplCopyWithImpl(
    _$TeamInfoModelImpl _value,
    $Res Function(_$TeamInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? shortname = freezed,
    Object? img = null,
  }) {
    return _then(
      _$TeamInfoModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortname: freezed == shortname
            ? _value.shortname
            : shortname // ignore: cast_nullable_to_non_nullable
                  as String?,
        img: null == img
            ? _value.img
            : img // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInfoModelImpl implements _TeamInfoModel {
  const _$TeamInfoModelImpl({this.name = '', this.shortname, this.img = ''});

  factory _$TeamInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInfoModelImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  final String? shortname;
  @override
  @JsonKey()
  final String img;

  @override
  String toString() {
    return 'TeamInfoModel(name: $name, shortname: $shortname, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInfoModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortname, shortname) ||
                other.shortname == shortname) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, shortname, img);

  /// Create a copy of TeamInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInfoModelImplCopyWith<_$TeamInfoModelImpl> get copyWith =>
      __$$TeamInfoModelImplCopyWithImpl<_$TeamInfoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInfoModelImplToJson(this);
  }
}

abstract class _TeamInfoModel implements TeamInfoModel {
  const factory _TeamInfoModel({
    final String name,
    final String? shortname,
    final String img,
  }) = _$TeamInfoModelImpl;

  factory _TeamInfoModel.fromJson(Map<String, dynamic> json) =
      _$TeamInfoModelImpl.fromJson;

  @override
  String get name;
  @override
  String? get shortname;
  @override
  String get img;

  /// Create a copy of TeamInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamInfoModelImplCopyWith<_$TeamInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
