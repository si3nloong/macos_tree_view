// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_view_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Node<T> _$NodeFromJson<T>(Map<String, dynamic> json) => Node<T>(
      key: const KeyOrNullConverter().fromJson(json['key'] as String),
      label: json['label'] as String,
      icon: const IconDataOrNullConverter().fromJson(json['icon'] as int?),
      iconColor:
          const ColorOrNullConverter().fromJson(json['iconColor'] as String?),
      selectedIconColor: const ColorOrNullConverter()
          .fromJson(json['selectedIconColor'] as String?),
      expanded: json['expanded'] as bool? ?? false,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Node<T>.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: GenericConverter<T?>().fromJson(json['data']),
    );

Map<String, dynamic> _$NodeToJson<T>(Node<T> instance) => <String, dynamic>{
      'key': const KeyOrNullConverter().toJson(instance.key),
      'label': instance.label,
      'icon': const IconDataOrNullConverter().toJson(instance.icon),
      'iconColor': const ColorOrNullConverter().toJson(instance.iconColor),
      'selectedIconColor':
          const ColorOrNullConverter().toJson(instance.selectedIconColor),
      'expanded': instance.expanded,
      'children': instance.children,
      'data': GenericConverter<T?>().toJson(instance.data),
    };

TreeViewController<T> _$TreeViewControllerFromJson<T>(
        Map<String, dynamic> json) =>
    TreeViewController<T>(
      selectedValues: (json['selectedValues'] as List<dynamic>?)
          ?.map((e) => const KeyOrNullConverter().fromJson(e as String))
          .toSet(),
      selectionMode:
          $enumDecodeNullable(_$SelectionModeEnumMap, json['selectionMode']) ??
              SelectionMode.single,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Node<T>.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TreeViewControllerToJson<T>(
        TreeViewController<T> instance) =>
    <String, dynamic>{
      'selectedValues': instance.selectedValues
          .map(const KeyOrNullConverter().toJson)
          .toList(),
      'children': instance.children,
      'selectionMode': _$SelectionModeEnumMap[instance.selectionMode],
    };

const _$SelectionModeEnumMap = {
  SelectionMode.none: 'none',
  SelectionMode.single: 'single',
  SelectionMode.multiple: 'multiple',
};
