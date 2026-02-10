// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) {
  return _MatchModel.fromJson(json);
}

/// @nodoc
mixin _$MatchModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get matchType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get dateTimeGMT => throw _privateConstructorUsedError;
  List<String> get teams => throw _privateConstructorUsedError;
  List<TeamInfoModel> get teamInfo => throw _privateConstructorUsedError;
  List<ScoreModel> get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'series_id')
  String get seriesId => throw _privateConstructorUsedError;
  bool get fantasyEnabled => throw _privateConstructorUsedError;
  bool get bbbEnabled => throw _privateConstructorUsedError;
  bool get hasSquad => throw _privateConstructorUsedError;
  bool get matchStarted => throw _privateConstructorUsedError;
  bool get matchEnded => throw _privateConstructorUsedError;
  List<PlayerModel> get players => throw _privateConstructorUsedError;

  /// Serializes this MatchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchModelCopyWith<MatchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchModelCopyWith<$Res> {
  factory $MatchModelCopyWith(
    MatchModel value,
    $Res Function(MatchModel) then,
  ) = _$MatchModelCopyWithImpl<$Res, MatchModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String matchType,
    String status,
    String venue,
    String date,
    String dateTimeGMT,
    List<String> teams,
    List<TeamInfoModel> teamInfo,
    List<ScoreModel> score,
    @JsonKey(name: 'series_id') String seriesId,
    bool fantasyEnabled,
    bool bbbEnabled,
    bool hasSquad,
    bool matchStarted,
    bool matchEnded,
    List<PlayerModel> players,
  });
}

/// @nodoc
class _$MatchModelCopyWithImpl<$Res, $Val extends MatchModel>
    implements $MatchModelCopyWith<$Res> {
  _$MatchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? matchType = null,
    Object? status = null,
    Object? venue = null,
    Object? date = null,
    Object? dateTimeGMT = null,
    Object? teams = null,
    Object? teamInfo = null,
    Object? score = null,
    Object? seriesId = null,
    Object? fantasyEnabled = null,
    Object? bbbEnabled = null,
    Object? hasSquad = null,
    Object? matchStarted = null,
    Object? matchEnded = null,
    Object? players = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            matchType: null == matchType
                ? _value.matchType
                : matchType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            venue: null == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            dateTimeGMT: null == dateTimeGMT
                ? _value.dateTimeGMT
                : dateTimeGMT // ignore: cast_nullable_to_non_nullable
                      as String,
            teams: null == teams
                ? _value.teams
                : teams // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            teamInfo: null == teamInfo
                ? _value.teamInfo
                : teamInfo // ignore: cast_nullable_to_non_nullable
                      as List<TeamInfoModel>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as List<ScoreModel>,
            seriesId: null == seriesId
                ? _value.seriesId
                : seriesId // ignore: cast_nullable_to_non_nullable
                      as String,
            fantasyEnabled: null == fantasyEnabled
                ? _value.fantasyEnabled
                : fantasyEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            bbbEnabled: null == bbbEnabled
                ? _value.bbbEnabled
                : bbbEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasSquad: null == hasSquad
                ? _value.hasSquad
                : hasSquad // ignore: cast_nullable_to_non_nullable
                      as bool,
            matchStarted: null == matchStarted
                ? _value.matchStarted
                : matchStarted // ignore: cast_nullable_to_non_nullable
                      as bool,
            matchEnded: null == matchEnded
                ? _value.matchEnded
                : matchEnded // ignore: cast_nullable_to_non_nullable
                      as bool,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<PlayerModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchModelImplCopyWith<$Res>
    implements $MatchModelCopyWith<$Res> {
  factory _$$MatchModelImplCopyWith(
    _$MatchModelImpl value,
    $Res Function(_$MatchModelImpl) then,
  ) = __$$MatchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String matchType,
    String status,
    String venue,
    String date,
    String dateTimeGMT,
    List<String> teams,
    List<TeamInfoModel> teamInfo,
    List<ScoreModel> score,
    @JsonKey(name: 'series_id') String seriesId,
    bool fantasyEnabled,
    bool bbbEnabled,
    bool hasSquad,
    bool matchStarted,
    bool matchEnded,
    List<PlayerModel> players,
  });
}

/// @nodoc
class __$$MatchModelImplCopyWithImpl<$Res>
    extends _$MatchModelCopyWithImpl<$Res, _$MatchModelImpl>
    implements _$$MatchModelImplCopyWith<$Res> {
  __$$MatchModelImplCopyWithImpl(
    _$MatchModelImpl _value,
    $Res Function(_$MatchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? matchType = null,
    Object? status = null,
    Object? venue = null,
    Object? date = null,
    Object? dateTimeGMT = null,
    Object? teams = null,
    Object? teamInfo = null,
    Object? score = null,
    Object? seriesId = null,
    Object? fantasyEnabled = null,
    Object? bbbEnabled = null,
    Object? hasSquad = null,
    Object? matchStarted = null,
    Object? matchEnded = null,
    Object? players = null,
  }) {
    return _then(
      _$MatchModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        matchType: null == matchType
            ? _value.matchType
            : matchType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        venue: null == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        dateTimeGMT: null == dateTimeGMT
            ? _value.dateTimeGMT
            : dateTimeGMT // ignore: cast_nullable_to_non_nullable
                  as String,
        teams: null == teams
            ? _value._teams
            : teams // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        teamInfo: null == teamInfo
            ? _value._teamInfo
            : teamInfo // ignore: cast_nullable_to_non_nullable
                  as List<TeamInfoModel>,
        score: null == score
            ? _value._score
            : score // ignore: cast_nullable_to_non_nullable
                  as List<ScoreModel>,
        seriesId: null == seriesId
            ? _value.seriesId
            : seriesId // ignore: cast_nullable_to_non_nullable
                  as String,
        fantasyEnabled: null == fantasyEnabled
            ? _value.fantasyEnabled
            : fantasyEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        bbbEnabled: null == bbbEnabled
            ? _value.bbbEnabled
            : bbbEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasSquad: null == hasSquad
            ? _value.hasSquad
            : hasSquad // ignore: cast_nullable_to_non_nullable
                  as bool,
        matchStarted: null == matchStarted
            ? _value.matchStarted
            : matchStarted // ignore: cast_nullable_to_non_nullable
                  as bool,
        matchEnded: null == matchEnded
            ? _value.matchEnded
            : matchEnded // ignore: cast_nullable_to_non_nullable
                  as bool,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<PlayerModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchModelImpl implements _MatchModel {
  const _$MatchModelImpl({
    this.id = '',
    this.name = '',
    this.matchType = '',
    this.status = '',
    this.venue = '',
    this.date = '',
    this.dateTimeGMT = '',
    final List<String> teams = const [],
    final List<TeamInfoModel> teamInfo = const [],
    final List<ScoreModel> score = const [],
    @JsonKey(name: 'series_id') this.seriesId = '',
    this.fantasyEnabled = false,
    this.bbbEnabled = false,
    this.hasSquad = false,
    this.matchStarted = false,
    this.matchEnded = false,
    final List<PlayerModel> players = const [],
  }) : _teams = teams,
       _teamInfo = teamInfo,
       _score = score,
       _players = players;

  factory _$MatchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String matchType;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String venue;
  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final String dateTimeGMT;
  final List<String> _teams;
  @override
  @JsonKey()
  List<String> get teams {
    if (_teams is EqualUnmodifiableListView) return _teams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teams);
  }

  final List<TeamInfoModel> _teamInfo;
  @override
  @JsonKey()
  List<TeamInfoModel> get teamInfo {
    if (_teamInfo is EqualUnmodifiableListView) return _teamInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teamInfo);
  }

  final List<ScoreModel> _score;
  @override
  @JsonKey()
  List<ScoreModel> get score {
    if (_score is EqualUnmodifiableListView) return _score;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_score);
  }

  @override
  @JsonKey(name: 'series_id')
  final String seriesId;
  @override
  @JsonKey()
  final bool fantasyEnabled;
  @override
  @JsonKey()
  final bool bbbEnabled;
  @override
  @JsonKey()
  final bool hasSquad;
  @override
  @JsonKey()
  final bool matchStarted;
  @override
  @JsonKey()
  final bool matchEnded;
  final List<PlayerModel> _players;
  @override
  @JsonKey()
  List<PlayerModel> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'MatchModel(id: $id, name: $name, matchType: $matchType, status: $status, venue: $venue, date: $date, dateTimeGMT: $dateTimeGMT, teams: $teams, teamInfo: $teamInfo, score: $score, seriesId: $seriesId, fantasyEnabled: $fantasyEnabled, bbbEnabled: $bbbEnabled, hasSquad: $hasSquad, matchStarted: $matchStarted, matchEnded: $matchEnded, players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.matchType, matchType) ||
                other.matchType == matchType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.dateTimeGMT, dateTimeGMT) ||
                other.dateTimeGMT == dateTimeGMT) &&
            const DeepCollectionEquality().equals(other._teams, _teams) &&
            const DeepCollectionEquality().equals(other._teamInfo, _teamInfo) &&
            const DeepCollectionEquality().equals(other._score, _score) &&
            (identical(other.seriesId, seriesId) ||
                other.seriesId == seriesId) &&
            (identical(other.fantasyEnabled, fantasyEnabled) ||
                other.fantasyEnabled == fantasyEnabled) &&
            (identical(other.bbbEnabled, bbbEnabled) ||
                other.bbbEnabled == bbbEnabled) &&
            (identical(other.hasSquad, hasSquad) ||
                other.hasSquad == hasSquad) &&
            (identical(other.matchStarted, matchStarted) ||
                other.matchStarted == matchStarted) &&
            (identical(other.matchEnded, matchEnded) ||
                other.matchEnded == matchEnded) &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    matchType,
    status,
    venue,
    date,
    dateTimeGMT,
    const DeepCollectionEquality().hash(_teams),
    const DeepCollectionEquality().hash(_teamInfo),
    const DeepCollectionEquality().hash(_score),
    seriesId,
    fantasyEnabled,
    bbbEnabled,
    hasSquad,
    matchStarted,
    matchEnded,
    const DeepCollectionEquality().hash(_players),
  );

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      __$$MatchModelImplCopyWithImpl<_$MatchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchModelImplToJson(this);
  }
}

abstract class _MatchModel implements MatchModel {
  const factory _MatchModel({
    final String id,
    final String name,
    final String matchType,
    final String status,
    final String venue,
    final String date,
    final String dateTimeGMT,
    final List<String> teams,
    final List<TeamInfoModel> teamInfo,
    final List<ScoreModel> score,
    @JsonKey(name: 'series_id') final String seriesId,
    final bool fantasyEnabled,
    final bool bbbEnabled,
    final bool hasSquad,
    final bool matchStarted,
    final bool matchEnded,
    final List<PlayerModel> players,
  }) = _$MatchModelImpl;

  factory _MatchModel.fromJson(Map<String, dynamic> json) =
      _$MatchModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get matchType;
  @override
  String get status;
  @override
  String get venue;
  @override
  String get date;
  @override
  String get dateTimeGMT;
  @override
  List<String> get teams;
  @override
  List<TeamInfoModel> get teamInfo;
  @override
  List<ScoreModel> get score;
  @override
  @JsonKey(name: 'series_id')
  String get seriesId;
  @override
  bool get fantasyEnabled;
  @override
  bool get bbbEnabled;
  @override
  bool get hasSquad;
  @override
  bool get matchStarted;
  @override
  bool get matchEnded;
  @override
  List<PlayerModel> get players;

  /// Create a copy of MatchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchModelImplCopyWith<_$MatchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
