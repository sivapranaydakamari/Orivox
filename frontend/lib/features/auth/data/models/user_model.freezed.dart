// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProjectRoleAccessModel _$ProjectRoleAccessModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProjectRoleAccessModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectRoleAccessModel {
  String get projectId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this ProjectRoleAccessModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectRoleAccessModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectRoleAccessModelCopyWith<ProjectRoleAccessModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectRoleAccessModelCopyWith<$Res> {
  factory $ProjectRoleAccessModelCopyWith(
    ProjectRoleAccessModel value,
    $Res Function(ProjectRoleAccessModel) then,
  ) = _$ProjectRoleAccessModelCopyWithImpl<$Res, ProjectRoleAccessModel>;
  @useResult
  $Res call({String projectId, String role});
}

/// @nodoc
class _$ProjectRoleAccessModelCopyWithImpl<
  $Res,
  $Val extends ProjectRoleAccessModel
>
    implements $ProjectRoleAccessModelCopyWith<$Res> {
  _$ProjectRoleAccessModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectRoleAccessModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? projectId = null, Object? role = null}) {
    return _then(
      _value.copyWith(
            projectId:
                null == projectId
                    ? _value.projectId
                    : projectId // ignore: cast_nullable_to_non_nullable
                        as String,
            role:
                null == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectRoleAccessModelImplCopyWith<$Res>
    implements $ProjectRoleAccessModelCopyWith<$Res> {
  factory _$$ProjectRoleAccessModelImplCopyWith(
    _$ProjectRoleAccessModelImpl value,
    $Res Function(_$ProjectRoleAccessModelImpl) then,
  ) = __$$ProjectRoleAccessModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String projectId, String role});
}

/// @nodoc
class __$$ProjectRoleAccessModelImplCopyWithImpl<$Res>
    extends
        _$ProjectRoleAccessModelCopyWithImpl<$Res, _$ProjectRoleAccessModelImpl>
    implements _$$ProjectRoleAccessModelImplCopyWith<$Res> {
  __$$ProjectRoleAccessModelImplCopyWithImpl(
    _$ProjectRoleAccessModelImpl _value,
    $Res Function(_$ProjectRoleAccessModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectRoleAccessModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? projectId = null, Object? role = null}) {
    return _then(
      _$ProjectRoleAccessModelImpl(
        projectId:
            null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                    as String,
        role:
            null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectRoleAccessModelImpl extends _ProjectRoleAccessModel {
  const _$ProjectRoleAccessModelImpl({
    required this.projectId,
    required this.role,
  }) : super._();

  factory _$ProjectRoleAccessModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectRoleAccessModelImplFromJson(json);

  @override
  final String projectId;
  @override
  final String role;

  @override
  String toString() {
    return 'ProjectRoleAccessModel(projectId: $projectId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectRoleAccessModelImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, projectId, role);

  /// Create a copy of ProjectRoleAccessModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectRoleAccessModelImplCopyWith<_$ProjectRoleAccessModelImpl>
  get copyWith =>
      __$$ProjectRoleAccessModelImplCopyWithImpl<_$ProjectRoleAccessModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectRoleAccessModelImplToJson(this);
  }
}

abstract class _ProjectRoleAccessModel extends ProjectRoleAccessModel {
  const factory _ProjectRoleAccessModel({
    required final String projectId,
    required final String role,
  }) = _$ProjectRoleAccessModelImpl;
  const _ProjectRoleAccessModel._() : super._();

  factory _ProjectRoleAccessModel.fromJson(Map<String, dynamic> json) =
      _$ProjectRoleAccessModelImpl.fromJson;

  @override
  String get projectId;
  @override
  String get role;

  /// Create a copy of ProjectRoleAccessModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectRoleAccessModelImplCopyWith<_$ProjectRoleAccessModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MembershipModel _$MembershipModelFromJson(Map<String, dynamic> json) {
  return _MembershipModel.fromJson(json);
}

/// @nodoc
mixin _$MembershipModel {
  String get organizationId => throw _privateConstructorUsedError;
  String get orgRole => throw _privateConstructorUsedError;
  List<ProjectRoleAccessModel> get projectRoles =>
      throw _privateConstructorUsedError;

  /// Serializes this MembershipModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MembershipModelCopyWith<MembershipModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipModelCopyWith<$Res> {
  factory $MembershipModelCopyWith(
    MembershipModel value,
    $Res Function(MembershipModel) then,
  ) = _$MembershipModelCopyWithImpl<$Res, MembershipModel>;
  @useResult
  $Res call({
    String organizationId,
    String orgRole,
    List<ProjectRoleAccessModel> projectRoles,
  });
}

/// @nodoc
class _$MembershipModelCopyWithImpl<$Res, $Val extends MembershipModel>
    implements $MembershipModelCopyWith<$Res> {
  _$MembershipModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? orgRole = null,
    Object? projectRoles = null,
  }) {
    return _then(
      _value.copyWith(
            organizationId:
                null == organizationId
                    ? _value.organizationId
                    : organizationId // ignore: cast_nullable_to_non_nullable
                        as String,
            orgRole:
                null == orgRole
                    ? _value.orgRole
                    : orgRole // ignore: cast_nullable_to_non_nullable
                        as String,
            projectRoles:
                null == projectRoles
                    ? _value.projectRoles
                    : projectRoles // ignore: cast_nullable_to_non_nullable
                        as List<ProjectRoleAccessModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MembershipModelImplCopyWith<$Res>
    implements $MembershipModelCopyWith<$Res> {
  factory _$$MembershipModelImplCopyWith(
    _$MembershipModelImpl value,
    $Res Function(_$MembershipModelImpl) then,
  ) = __$$MembershipModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String organizationId,
    String orgRole,
    List<ProjectRoleAccessModel> projectRoles,
  });
}

/// @nodoc
class __$$MembershipModelImplCopyWithImpl<$Res>
    extends _$MembershipModelCopyWithImpl<$Res, _$MembershipModelImpl>
    implements _$$MembershipModelImplCopyWith<$Res> {
  __$$MembershipModelImplCopyWithImpl(
    _$MembershipModelImpl _value,
    $Res Function(_$MembershipModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationId = null,
    Object? orgRole = null,
    Object? projectRoles = null,
  }) {
    return _then(
      _$MembershipModelImpl(
        organizationId:
            null == organizationId
                ? _value.organizationId
                : organizationId // ignore: cast_nullable_to_non_nullable
                    as String,
        orgRole:
            null == orgRole
                ? _value.orgRole
                : orgRole // ignore: cast_nullable_to_non_nullable
                    as String,
        projectRoles:
            null == projectRoles
                ? _value._projectRoles
                : projectRoles // ignore: cast_nullable_to_non_nullable
                    as List<ProjectRoleAccessModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipModelImpl extends _MembershipModel {
  const _$MembershipModelImpl({
    required this.organizationId,
    required this.orgRole,
    final List<ProjectRoleAccessModel> projectRoles = const [],
  }) : _projectRoles = projectRoles,
       super._();

  factory _$MembershipModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipModelImplFromJson(json);

  @override
  final String organizationId;
  @override
  final String orgRole;
  final List<ProjectRoleAccessModel> _projectRoles;
  @override
  @JsonKey()
  List<ProjectRoleAccessModel> get projectRoles {
    if (_projectRoles is EqualUnmodifiableListView) return _projectRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projectRoles);
  }

  @override
  String toString() {
    return 'MembershipModel(organizationId: $organizationId, orgRole: $orgRole, projectRoles: $projectRoles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipModelImpl &&
            (identical(other.organizationId, organizationId) ||
                other.organizationId == organizationId) &&
            (identical(other.orgRole, orgRole) || other.orgRole == orgRole) &&
            const DeepCollectionEquality().equals(
              other._projectRoles,
              _projectRoles,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    organizationId,
    orgRole,
    const DeepCollectionEquality().hash(_projectRoles),
  );

  /// Create a copy of MembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipModelImplCopyWith<_$MembershipModelImpl> get copyWith =>
      __$$MembershipModelImplCopyWithImpl<_$MembershipModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipModelImplToJson(this);
  }
}

abstract class _MembershipModel extends MembershipModel {
  const factory _MembershipModel({
    required final String organizationId,
    required final String orgRole,
    final List<ProjectRoleAccessModel> projectRoles,
  }) = _$MembershipModelImpl;
  const _MembershipModel._() : super._();

  factory _MembershipModel.fromJson(Map<String, dynamic> json) =
      _$MembershipModelImpl.fromJson;

  @override
  String get organizationId;
  @override
  String get orgRole;
  @override
  List<ProjectRoleAccessModel> get projectRoles;

  /// Create a copy of MembershipModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MembershipModelImplCopyWith<_$MembershipModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get globalRole => throw _privateConstructorUsedError;
  List<MembershipModel> get memberships => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String email,
    String globalRole,
    List<MembershipModel> memberships,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? globalRole = null,
    Object? memberships = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            globalRole:
                null == globalRole
                    ? _value.globalRole
                    : globalRole // ignore: cast_nullable_to_non_nullable
                        as String,
            memberships:
                null == memberships
                    ? _value.memberships
                    : memberships // ignore: cast_nullable_to_non_nullable
                        as List<MembershipModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String name,
    String email,
    String globalRole,
    List<MembershipModel> memberships,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? globalRole = null,
    Object? memberships = null,
  }) {
    return _then(
      _$UserModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        globalRole:
            null == globalRole
                ? _value.globalRole
                : globalRole // ignore: cast_nullable_to_non_nullable
                    as String,
        memberships:
            null == memberships
                ? _value._memberships
                : memberships // ignore: cast_nullable_to_non_nullable
                    as List<MembershipModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    @JsonKey(name: '_id') required this.id,
    required this.name,
    required this.email,
    this.globalRole = 'USER',
    final List<MembershipModel> memberships = const [],
  }) : _memberships = memberships,
       super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  @JsonKey()
  final String globalRole;
  final List<MembershipModel> _memberships;
  @override
  @JsonKey()
  List<MembershipModel> get memberships {
    if (_memberships is EqualUnmodifiableListView) return _memberships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberships);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, globalRole: $globalRole, memberships: $memberships)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.globalRole, globalRole) ||
                other.globalRole == globalRole) &&
            const DeepCollectionEquality().equals(
              other._memberships,
              _memberships,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    globalRole,
    const DeepCollectionEquality().hash(_memberships),
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    @JsonKey(name: '_id') required final String id,
    required final String name,
    required final String email,
    final String globalRole,
    final List<MembershipModel> memberships,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get globalRole;
  @override
  List<MembershipModel> get memberships;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
