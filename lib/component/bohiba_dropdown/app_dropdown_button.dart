// ignore_for_file: must_be_immutable

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? dropDownValue;
  final void Function(T?)? onChanged;
  final String Function(T) labelBuilder;
  final bool showIcon;
  final double? width;
  final double? height;
  final double? menuHeight;
  final EdgeInsets? padding;
  final String? hint;
  final bool enableSearch;
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
    this.padding = const EdgeInsets.symmetric(vertical: 5.0),
    this.hint,
    this.requestFocusOnTap = false,
    this.enableSearch = false,
    this.menuController,
    this.showIcon = true,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 47,
      width: widget.width ?? ScreenUtils.width,
      margin: EdgeInsets.symmetric(vertical: ScreenUtils.height5),
      child: DropdownMenu<T>(
        width: widget.width,
        initialSelection: widget.dropDownValue,
        controller: widget.menuController,
        requestFocusOnTap: widget.requestFocusOnTap,
        enableFilter: widget.enableSearch,
        hintText: widget.hint,
        menuHeight: widget.menuHeight ?? ScreenUtils.height * 0.4,
        trailingIcon: widget.showIcon == true
            ? Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: BohibaColors.greyColor,
              )
            : Container(),
        textStyle: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
          color: bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.2,
        ),
        selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: bohibaTheme.primaryColor,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
        ),
        expandedInsets: widget.padding,
        searchCallback: (entries, query) {
          if (query.isEmpty) return null;
          final index = entries.indexWhere(
            (entry) => widget
                .labelBuilder(entry.value!)
                .toLowerCase()
                .contains(query.toLowerCase()),
          );
          return index != -1 ? index : null;
        },
        dropdownMenuEntries: widget.items.map((T item) {
          final label = widget.labelBuilder(item);
          return DropdownMenuEntry<T>(
            value: item,
            label: label,
            labelWidget: Text(
              label,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                color: bohibaTheme.textTheme.titleLarge!.color,
                letterSpacing: 1.2,
              ),
            ),
          );
        }).toList(),
        onSelected: widget.onChanged,
      ),
    );
  }
}
