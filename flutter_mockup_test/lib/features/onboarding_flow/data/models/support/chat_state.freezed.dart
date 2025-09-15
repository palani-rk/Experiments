// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatState _$ChatStateFromJson(Map<String, dynamic> json) {
  return _ChatState.fromJson(json);
}

/// @nodoc
mixin _$ChatState {
  String get sessionId => throw _privateConstructorUsedError;
  List<ChatSection> get sections => throw _privateConstructorUsedError;
  String? get currentSectionId => throw _privateConstructorUsedError;
  String? get currentQuestionId => throw _privateConstructorUsedError;
  ChatStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this ChatState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatStateCopyWith<ChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
  @useResult
  $Res call(
      {String sessionId,
      List<ChatSection> sections,
      String? currentSectionId,
      String? currentQuestionId,
      ChatStatus status,
      DateTime createdAt,
      DateTime? completedAt,
      DateTime? lastActivityAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sections = null,
    Object? currentSectionId = freezed,
    Object? currentQuestionId = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? lastActivityAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<ChatSection>,
      currentSectionId: freezed == currentSectionId
          ? _value.currentSectionId
          : currentSectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentQuestionId: freezed == currentQuestionId
          ? _value.currentQuestionId
          : currentQuestionId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChatStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatStateImplCopyWith<$Res>
    implements $ChatStateCopyWith<$Res> {
  factory _$$ChatStateImplCopyWith(
          _$ChatStateImpl value, $Res Function(_$ChatStateImpl) then) =
      __$$ChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      List<ChatSection> sections,
      String? currentSectionId,
      String? currentQuestionId,
      ChatStatus status,
      DateTime createdAt,
      DateTime? completedAt,
      DateTime? lastActivityAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ChatStateImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatStateImpl>
    implements _$$ChatStateImplCopyWith<$Res> {
  __$$ChatStateImplCopyWithImpl(
      _$ChatStateImpl _value, $Res Function(_$ChatStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sections = null,
    Object? currentSectionId = freezed,
    Object? currentQuestionId = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? lastActivityAt = freezed,
    Object? metadata = null,
  }) {
    return _then(_$ChatStateImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sections: null == sections
          ? _value._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<ChatSection>,
      currentSectionId: freezed == currentSectionId
          ? _value.currentSectionId
          : currentSectionId // ignore: cast_nullable_to_non_nullable
              as String?,
      currentQuestionId: freezed == currentQuestionId
          ? _value.currentQuestionId
          : currentQuestionId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChatStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatStateImpl extends _ChatState {
  const _$ChatStateImpl(
      {required this.sessionId,
      required final List<ChatSection> sections,
      this.currentSectionId,
      this.currentQuestionId,
      this.status = ChatStatus.notStarted,
      required this.createdAt,
      this.completedAt,
      this.lastActivityAt,
      final Map<String, dynamic> metadata = const {}})
      : _sections = sections,
        _metadata = metadata,
        super._();

  factory _$ChatStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatStateImplFromJson(json);

  @override
  final String sessionId;
  final List<ChatSection> _sections;
  @override
  List<ChatSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  final String? currentSectionId;
  @override
  final String? currentQuestionId;
  @override
  @JsonKey()
  final ChatStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? lastActivityAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatStateImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality().equals(other._sections, _sections) &&
            (identical(other.currentSectionId, currentSectionId) ||
                other.currentSectionId == currentSectionId) &&
            (identical(other.currentQuestionId, currentQuestionId) ||
                other.currentQuestionId == currentQuestionId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      const DeepCollectionEquality().hash(_sections),
      currentSectionId,
      currentQuestionId,
      status,
      createdAt,
      completedAt,
      lastActivityAt,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      __$$ChatStateImplCopyWithImpl<_$ChatStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatStateImplToJson(
      this,
    );
  }
}

abstract class _ChatState extends ChatState {
  const factory _ChatState(
      {required final String sessionId,
      required final List<ChatSection> sections,
      final String? currentSectionId,
      final String? currentQuestionId,
      final ChatStatus status,
      required final DateTime createdAt,
      final DateTime? completedAt,
      final DateTime? lastActivityAt,
      final Map<String, dynamic> metadata}) = _$ChatStateImpl;
  const _ChatState._() : super._();

  factory _ChatState.fromJson(Map<String, dynamic> json) =
      _$ChatStateImpl.fromJson;

  @override
  String get sessionId;
  @override
  List<ChatSection> get sections;
  @override
  String? get currentSectionId;
  @override
  String? get currentQuestionId;
  @override
  ChatStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get lastActivityAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of ChatState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatStateImplCopyWith<_$ChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
