// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Node<T> _$$_NodeFromJson<T>(Map<String, dynamic> json) => _$_Node<T>(
      key: json['key'] as String,
      label: json['label'] as String,
      icon: const IconDataOrNullConverter().fromJson(json['icon']),
      iconColor:
          const ColorOrNullConverter().fromJson(json['iconColor'] as String?),
      selectedIconColor: const ColorOrNullConverter()
          .fromJson(json['selectedIconColor'] as String?),
      expanded: json['expanded'] as bool? ?? false,
      data:
          GenericConverter<T?>().fromJson(json['data'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => Node<T>.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_NodeToJson<T>(_$_Node<T> instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'icon': const IconDataOrNullConverter().toJson(instance.icon),
      'iconColor': const ColorOrNullConverter().toJson(instance.iconColor),
      'selectedIconColor':
          const ColorOrNullConverter().toJson(instance.selectedIconColor),
      'expanded': instance.expanded,
      'data': GenericConverter<T?>().toJson(instance.data),
      'children': instance.children,
    };
