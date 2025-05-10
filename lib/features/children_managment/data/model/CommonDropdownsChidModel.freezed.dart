// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'CommonDropdownsChidModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommonDropdownsChidModel _$CommonDropdownsChidModelFromJson(
    Map<String, dynamic> json) {
  return _CommonDropdownsChidModel.fromJson(json);
}

/// @nodoc
mixin _$CommonDropdownsChidModel {
  List<NationalityModel> get nationalities =>
      throw _privateConstructorUsedError;
  List<CountryModel> get countries => throw _privateConstructorUsedError;
  List<SpecialCase> get specialCases => throw _privateConstructorUsedError;

  /// Serializes this CommonDropdownsChidModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommonDropdownsChidModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommonDropdownsChidModelCopyWith<CommonDropdownsChidModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonDropdownsChidModelCopyWith<$Res> {
  factory $CommonDropdownsChidModelCopyWith(CommonDropdownsChidModel value,
          $Res Function(CommonDropdownsChidModel) then) =
      _$CommonDropdownsChidModelCopyWithImpl<$Res, CommonDropdownsChidModel>;
  @useResult
  $Res call(
      {List<NationalityModel> nationalities,
      List<CountryModel> countries,
      List<SpecialCase> specialCases});
}

/// @nodoc
class _$CommonDropdownsChidModelCopyWithImpl<$Res,
        $Val extends CommonDropdownsChidModel>
    implements $CommonDropdownsChidModelCopyWith<$Res> {
  _$CommonDropdownsChidModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommonDropdownsChidModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nationalities = null,
    Object? countries = null,
    Object? specialCases = null,
  }) {
    return _then(_value.copyWith(
      nationalities: null == nationalities
          ? _value.nationalities
          : nationalities // ignore: cast_nullable_to_non_nullable
              as List<NationalityModel>,
      countries: null == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<CountryModel>,
      specialCases: null == specialCases
          ? _value.specialCases
          : specialCases // ignore: cast_nullable_to_non_nullable
              as List<SpecialCase>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonDropdownsChidModelImplCopyWith<$Res>
    implements $CommonDropdownsChidModelCopyWith<$Res> {
  factory _$$CommonDropdownsChidModelImplCopyWith(
          _$CommonDropdownsChidModelImpl value,
          $Res Function(_$CommonDropdownsChidModelImpl) then) =
      __$$CommonDropdownsChidModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<NationalityModel> nationalities,
      List<CountryModel> countries,
      List<SpecialCase> specialCases});
}

/// @nodoc
class __$$CommonDropdownsChidModelImplCopyWithImpl<$Res>
    extends _$CommonDropdownsChidModelCopyWithImpl<$Res,
        _$CommonDropdownsChidModelImpl>
    implements _$$CommonDropdownsChidModelImplCopyWith<$Res> {
  __$$CommonDropdownsChidModelImplCopyWithImpl(
      _$CommonDropdownsChidModelImpl _value,
      $Res Function(_$CommonDropdownsChidModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommonDropdownsChidModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nationalities = null,
    Object? countries = null,
    Object? specialCases = null,
  }) {
    return _then(_$CommonDropdownsChidModelImpl(
      nationalities: null == nationalities
          ? _value._nationalities
          : nationalities // ignore: cast_nullable_to_non_nullable
              as List<NationalityModel>,
      countries: null == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<CountryModel>,
      specialCases: null == specialCases
          ? _value._specialCases
          : specialCases // ignore: cast_nullable_to_non_nullable
              as List<SpecialCase>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonDropdownsChidModelImpl implements _CommonDropdownsChidModel {
  const _$CommonDropdownsChidModelImpl(
      {required final List<NationalityModel> nationalities,
      required final List<CountryModel> countries,
      required final List<SpecialCase> specialCases})
      : _nationalities = nationalities,
        _countries = countries,
        _specialCases = specialCases;

  factory _$CommonDropdownsChidModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonDropdownsChidModelImplFromJson(json);

  final List<NationalityModel> _nationalities;
  @override
  List<NationalityModel> get nationalities {
    if (_nationalities is EqualUnmodifiableListView) return _nationalities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nationalities);
  }

  final List<CountryModel> _countries;
  @override
  List<CountryModel> get countries {
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_countries);
  }

  final List<SpecialCase> _specialCases;
  @override
  List<SpecialCase> get specialCases {
    if (_specialCases is EqualUnmodifiableListView) return _specialCases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialCases);
  }

  @override
  String toString() {
    return 'CommonDropdownsChidModel(nationalities: $nationalities, countries: $countries, specialCases: $specialCases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonDropdownsChidModelImpl &&
            const DeepCollectionEquality()
                .equals(other._nationalities, _nationalities) &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries) &&
            const DeepCollectionEquality()
                .equals(other._specialCases, _specialCases));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nationalities),
      const DeepCollectionEquality().hash(_countries),
      const DeepCollectionEquality().hash(_specialCases));

  /// Create a copy of CommonDropdownsChidModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonDropdownsChidModelImplCopyWith<_$CommonDropdownsChidModelImpl>
      get copyWith => __$$CommonDropdownsChidModelImplCopyWithImpl<
          _$CommonDropdownsChidModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonDropdownsChidModelImplToJson(
      this,
    );
  }
}

abstract class _CommonDropdownsChidModel implements CommonDropdownsChidModel {
  const factory _CommonDropdownsChidModel(
          {required final List<NationalityModel> nationalities,
          required final List<CountryModel> countries,
          required final List<SpecialCase> specialCases}) =
      _$CommonDropdownsChidModelImpl;

  factory _CommonDropdownsChidModel.fromJson(Map<String, dynamic> json) =
      _$CommonDropdownsChidModelImpl.fromJson;

  @override
  List<NationalityModel> get nationalities;
  @override
  List<CountryModel> get countries;
  @override
  List<SpecialCase> get specialCases;

  /// Create a copy of CommonDropdownsChidModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommonDropdownsChidModelImplCopyWith<_$CommonDropdownsChidModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
