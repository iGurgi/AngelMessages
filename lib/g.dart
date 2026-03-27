// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:angel_messages/features/messages/data/models/message_model.dart';
import 'package:angel_messages/features/settings/data/models/user_settings_model.dart';

// IsarCollection for MessageModel
const Schema messageModelSchema = CollectionSchema(
  name: r'MessageModel',
  id: 1,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'author': PropertySchema(
      id: 2,
      name: r'author',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.string,
    ),
    r'scheduledFor': PropertySchema(
      id: 4,
      name: r'scheduledFor',
      type: IsarType.dateTime,
    ),
    r'isRead': PropertySchema(
      id: 5,
      name: r'isRead',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 6,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 7,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'tags': PropertySchema(
      id: 8,
      name: r'tags',
      type: IsarType.stringList,
    ),
  },
  estimateSize: _messageModelEstimateSize,
  serialize: _messageModelSerialize,
  deserialize: _messageModelDeserialize,
  deserializeProp: _messageModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -905639846,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'scheduledFor': IndexSchema(
      id: 724314045,
      name: r'scheduledFor',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scheduledFor',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'category': IndexSchema(
      id: -486508069,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _messageModelGetId,
  getLinks: _messageModelGetLinks,
  attach: _messageModelAttach,
  version: '3.1.0+1',
);

int _messageModelEstimateSize(
  MessageModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.author.length * 3;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _messageModelSerialize(
  MessageModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.author);
  writer.writeString(offsets[1], object.category);
  writer.writeString(offsets[2], object.content);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isFavorite);
  writer.writeBool(offsets[6], object.isRead);
  writer.writeDateTime(offsets[7], object.scheduledFor);
  writer.writeStringList(offsets[8], object.tags);
}

MessageModel _messageModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MessageModel(
    author: reader.readString(offsets[0]),
    category: reader.readString(offsets[1]),
    content: reader.readString(offsets[2]),
    createdAt: reader.readDateTime(offsets[3]),
    id: reader.readString(offsets[4]),
    isFavorite: reader.readBool(offsets[5]),
    isRead: reader.readBool(offsets[6]),
    scheduledFor: reader.readDateTime(offsets[7]),
    tags: reader.readStringList(offsets[8]) ?? [],
  );
  object.isarId = id;
  return object;
}

P _messageModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _messageModelGetId(MessageModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _messageModelGetLinks(MessageModel object) {
  return [];
}

void _messageModelAttach(
    IsarCollection<dynamic> col, Id id, MessageModel object) {
  object.isarId = id;
}

extension MessageModelQueryWhereSort
    on QueryBuilder<MessageModel, MessageModel, QWhere> {
  QueryBuilder<MessageModel, MessageModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MessageModel, MessageModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'id'),
      );
    });
  }

  QueryBuilder<MessageModel, MessageModel, QAfterWhere> anyScheduledFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'scheduledFor'),
      );
    });
  }

  QueryBuilder<MessageModel, MessageModel, QAfterWhere> anyCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'category'),
      );
    });
  }
}

// IsarCollection for UserSettingsModel
const Schema userSettingsModelSchema = CollectionSchema(
  name: r'UserSettingsModel',
  id: 2,
  properties: {
    r'userId': PropertySchema(
      id: 0,
      name: r'userId',
      type: IsarType.string,
    ),
    r'notificationsEnabled': PropertySchema(
      id: 1,
      name: r'notificationsEnabled',
      type: IsarType.bool,
    ),
    r'dailyNotificationTime': PropertySchema(
      id: 2,
      name: r'dailyNotificationTime',
      type: IsarType.string,
    ),
    r'preferredCategories': PropertySchema(
      id: 3,
      name: r'preferredCategories',
      type: IsarType.stringList,
    ),
    r'theme': PropertySchema(
      id: 4,
      name: r'theme',
      type: IsarType.string,
    ),
    r'fontSize': PropertySchema(
      id: 5,
      name: r'fontSize',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _userSettingsModelEstimateSize,
  serialize: _userSettingsModelSerialize,
  deserialize: _userSettingsModelDeserialize,
  deserializeProp: _userSettingsModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'userId': IndexSchema(
      id: 456448374,
      name: r'userId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _userSettingsModelGetId,
  getLinks: _userSettingsModelGetLinks,
  attach: _userSettingsModelAttach,
  version: '3.1.0+1',
);

int _userSettingsModelEstimateSize(
  UserSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dailyNotificationTime.length * 3;
  bytesCount += 3 + object.preferredCategories.length * 3;
  {
    for (var i = 0; i < object.preferredCategories.length; i++) {
      final value = object.preferredCategories[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.theme.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _userSettingsModelSerialize(
  UserSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dailyNotificationTime);
  writer.writeDouble(offsets[1], object.fontSize);
  writer.writeBool(offsets[2], object.notificationsEnabled);
  writer.writeStringList(offsets[3], object.preferredCategories);
  writer.writeString(offsets[4], object.theme);
  writer.writeDateTime(offsets[5], object.updatedAt);
  writer.writeString(offsets[6], object.userId);
}

UserSettingsModel _userSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserSettingsModel(
    dailyNotificationTime: reader.readString(offsets[0]),
    fontSize: reader.readDouble(offsets[1]),
    notificationsEnabled: reader.readBool(offsets[2]),
    preferredCategories: reader.readStringList(offsets[3]) ?? [],
    theme: reader.readString(offsets[4]),
    updatedAt: reader.readDateTime(offsets[5]),
    userId: reader.readString(offsets[6]),
  );
  object.isarId = id;
  return object;
}

P _userSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userSettingsModelGetId(UserSettingsModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _userSettingsModelGetLinks(
    UserSettingsModel object) {
  return [];
}

void _userSettingsModelAttach(
    IsarCollection<dynamic> col, Id id, UserSettingsModel object) {
  object.isarId = id;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarDatabaseHash() => r'8f5b2c4e9d1a3b7c6e8f0a2b4d6e8f1a3b5c7e9f';

/// Database instance provider for Isar
///
/// Provides a singleton instance of the Isar database for the app
@ProviderFor(isarDatabase)
final isarDatabaseProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});

String _$messageRepositoryHash() => r'9a6b3c5d7e8f1a2b4c6d8e9f1a3b5c7d9e0f2a4b';

/// Repository for message data operations
///
/// Handles local storage and API synchronization for messages
@ProviderFor(messageRepository)
final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  throw UnimplementedError();
});

String _$notificationServiceHash() => r'2a4b6c8d0e1f3a5b7c9d1e3f5a7b9c1d3e5f7a9b';

/// Service for handling local notifications
///
/// Manages scheduling and displaying of daily angel messages
@ProviderFor(notificationService)
final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError();
});

String _$settingsRepositoryHash() => r'3b5c7d9e1f2a4b6c8d0e2f4a6b8c0d2e4f6a8b0c';

/// Repository for user settings operations
///
/// Handles local storage of user preferences and configuration
@ProviderFor(settingsRepository)
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError();
});

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return _MessageDto.fromJson(json);
}

/// @nodoc
mixin _$MessageDto {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get scheduledFor => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageDtoCopyWith<MessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageDtoCopyWith<$Res> {
  factory $MessageDtoCopyWith(
          MessageDto value, $Res Function(MessageDto) then) =
      _$MessageDtoCopyWithImpl<$Res, MessageDto>;
  @useResult
  $Res call(
      {String id,
      String content,
      String author,
      String category,
      DateTime scheduledFor,
      DateTime createdAt,
      List<String> tags});
}

/// @nodoc
class _$MessageDtoCopyWithImpl<$Res, $Val extends MessageDto>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? author = null,
    Object? category = null,
    Object? scheduledFor = null,
    Object? createdAt = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledFor: null == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageDtoImplCopyWith<$Res>
    implements $MessageDtoCopyWith<$Res> {
  factory _$$MessageDtoImplCopyWith(
          _$MessageDtoImpl value, $Res Function(_$MessageDtoImpl) then) =
      __$$MessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String content,
      String author,
      String category,
      DateTime scheduledFor,
      DateTime createdAt,
      List<String> tags});
}

/// @nodoc
class __$$MessageDtoImplCopyWithImpl<$Res>
    extends _$MessageDtoCopyWithImpl<$Res, _$MessageDtoImpl>
    implements _$$MessageDtoImplCopyWith<$Res> {
  __$$MessageDtoImplCopyWithImpl(
      _$MessageDtoImpl _value, $Res Function(_$MessageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? author = null,
    Object? category = null,
    Object? scheduledFor = null,
    Object? createdAt = null,
    Object? tags = null,
  }) {
    return _then(_$MessageDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledFor: null == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageDtoImpl implements _MessageDto {
  const _$MessageDtoImpl(
      {required this.id,
      required this.content,
      required this.author,
      required this.category,
      required this.scheduledFor,
      required this.createdAt,
      required final List<String> tags})
      : _tags = tags;

  factory _$MessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String author;
  @override
  final String category;
  @override
  final DateTime scheduledFor;
  @override
  final DateTime createdAt;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'MessageDto(id: $id, content: $content, author: $author, category: $category, scheduledFor: $scheduledFor, createdAt: $createdAt, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) ||
                other.content == content) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      content,
      author,
      category,
      scheduledFor,
      createdAt,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith =>
      __$$MessageDtoImplCopyWithImpl<_$MessageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageDtoImplToJson(
      this,
    );
  }
}

abstract class _MessageDto implements MessageDto {
  const factory _MessageDto(
      {required final String id,
      required final String content,
      required final String author,
      required final String category,
      required final DateTime scheduledFor,
      required final DateTime createdAt,
      required final List<String> tags}) = _$MessageDtoImpl;

  factory _MessageDto.fromJson(Map<String, dynamic> json) =
      _$MessageDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get author;
  @override
  String get category;
  @override
  DateTime get scheduledFor;
  @override
  DateTime get createdAt;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$MessageDtoImplCopyWith<_$MessageDtoImpl> get copyWith;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageDtoImpl _$$MessageDtoImplFromJson(Map<String, dynamic> json) =>
    _$MessageDtoImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      scheduledFor: DateTime.parse(json['scheduledFor'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$MessageDtoImplToJson(_$MessageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'category': instance.category,
      'scheduledFor': instance.scheduledFor.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'tags': instance.tags,
    };
