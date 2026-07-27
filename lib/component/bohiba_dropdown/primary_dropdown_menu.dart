import 'package:bohiba/extensions/bohiba_extension.dart';

import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class PrimaryDropDownMenu extends StatefulWidget {
  final double? width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets? contentPadding;
  final List<String> items;
  final String? hint;
  final String? dropDownValue;
  final double? menuHeight;
  final Color? filledColor;
  final Color? fontColor;
  final TextEditingController? menuController;
  final void Function(String?)? onChanged;
  final bool showIcon;
  final bool focusOnTap;
  final bool enableSearch;
  final TextInputAction? nextActionType;
  const PrimaryDropDownMenu({
    super.key,
    this.width,
    this.height = 47,
    this.padding = const EdgeInsets.symmetric(vertical: 5.0),
    this.contentPadding,
    this.hint,
    this.items = const [],
    this.dropDownValue,
    this.menuHeight,
    this.filledColor,
    this.fontColor,
    this.menuController,
    this.onChanged,
    this.showIcon = true,
    this.focusOnTap = false,
    this.enableSearch = false,
    this.nextActionType,
  });

  @override
  State<PrimaryDropDownMenu> createState() => _PrimaryDropDownMenuState();
}

class _PrimaryDropDownMenuState extends State<PrimaryDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width ?? ScreenUtils.width,
      margin: EdgeInsets.symmetric(vertical: ScreenUtils.height5),
      child: DropdownMenu<String?>(
        width: widget.width,
        initialSelection: widget.dropDownValue,
        controller: widget.menuController,
        requestFocusOnTap: widget.focusOnTap,
        enableFilter: widget.enableSearch,
        textInputAction: widget.nextActionType,
        hintText: widget.hint,
        menuHeight: widget.menuHeight ?? ScreenUtils.height * 0.4,
        showTrailingIcon: widget.showIcon,
        trailingIcon: Icon(
          Icons.keyboard_arrow_down,
          size: 10,
          color: BohibaColors.greyColor,
        ),
        textStyle: TextStyle(
          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
          color: widget.fontColor ?? bohibaTheme.textTheme.bodyLarge!.color,
          letterSpacing: 1.2,
        ),
        selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
        expandedInsets: widget.padding,
        inputDecorationTheme: InputDecorationTheme(
          filled: widget.filledColor != null ? true : false,
          fillColor: widget.filledColor,
          suffixIconColor: bohibaTheme.primaryColor,
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
        ),
        searchCallback: (entries, query) {
          if (query.isEmpty) {
            return null;
          }
          final int index = entries.indexWhere(
            (entry) => entry.label.toLowerCase().contains(query),
          );
          return index != -1 ? index : null;
        },
        dropdownMenuEntries: widget.items.map((String item) {
          return DropdownMenuEntry(
            value: item,
            label: item,
            labelWidget: Text(
              item.toCapitalizedLabel(),
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
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
