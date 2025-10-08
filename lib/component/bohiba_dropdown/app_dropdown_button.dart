// ignore_for_file: must_be_immutable

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? dropDownValue;
  final void Function(T?)? onChanged;
  final String Function(T) labelBuilder;
  final double? width;
  final double? height;
  final double? menuHeight;
  final EdgeInsets? padding;
  final String? hint;
  final bool enableFilter;
  final bool requestFocusOnTap;
  final TextEditingController? menuController;

  const AppDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.dropDownValue,
    this.onChanged,
    this.width,
    this.height,
    this.menuHeight,
    this.padding,
    this.hint,
    this.requestFocusOnTap = false,
    this.enableFilter = false,
    this.menuController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 47,
      width: width ?? ScreenUtils.width,
      margin: EdgeInsets.only(
        top: ScreenUtils.height5,
        bottom: ScreenUtils.height15,
      ),
      child: DropdownMenu<T>(
        width: width ?? ScreenUtils.width,
        initialSelection: dropDownValue,
        controller: menuController,
        requestFocusOnTap: requestFocusOnTap,
        enableFilter: enableFilter,
        hintText: hint,
        menuHeight: menuHeight ?? ScreenUtils.height * 0.4,
        trailingIcon: Icon(
          Icons.keyboard_arrow_down,
          size: 24,
          color: bohibaTheme.textTheme.titleSmall!.color,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          isCollapsed: false,
        ),
        expandedInsets: padding,
        textStyle: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge?.fontSize,
          color: bohibaTheme.textTheme.bodyLarge?.color,
          letterSpacing: 1.2,
        ),
        searchCallback: (entries, query) {
          if (query.isEmpty) return null;
          final index = entries.indexWhere(
            (entry) => labelBuilder(entry.value!)
                .toLowerCase()
                .contains(query.toLowerCase()),
          );
          return index != -1 ? index : null;
        },
        dropdownMenuEntries: items.map((T item) {
          final label = labelBuilder(item);
          return DropdownMenuEntry<T>(
            value: item,
            label: label,
            labelWidget: Text(
              label,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodyMedium?.fontSize,
                fontWeight: bohibaTheme.textTheme.bodyLarge?.fontWeight,
                color: bohibaTheme.textTheme.titleLarge?.color,
                letterSpacing: 1.2,
              ),
            ),
          );
        }).toList(),
        onSelected: onChanged,
      ),
    );
  }
}
