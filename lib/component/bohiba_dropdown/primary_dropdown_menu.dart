import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import '/theme/bohiba_theme.dart';

class PrimaryDropDownMenu extends StatefulWidget {
  final double? width;
  final double height;
  final EdgeInsets padding;
  final List<String> items;
  final String? hint;
  final String? dropDownValue;
  final double? menuHeight;
  final TextEditingController? menuController;
  final void Function(String?)? onChanged;
  final bool showIcon;
  final bool focusOnTap;
  final bool enableSearch;
  final TextInputAction? nextActionType;
  const PrimaryDropDownMenu({
    super.key,
    this.width,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(vertical: 5.0),
    this.hint,
    this.items = const [],
    this.dropDownValue,
    this.menuHeight,
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
      height: 47,
      width: widget.width ?? ScreenUtils.width,
      margin: EdgeInsets.only(
        top: ScreenUtils.height5,
        bottom: ScreenUtils.height15,
      ),
      child: DropdownMenu<String?>(
        width: widget.width,
        initialSelection: widget.dropDownValue,
        controller: widget.menuController,
        requestFocusOnTap: widget.focusOnTap,
        enableFilter: widget.enableSearch,
        textInputAction: widget.nextActionType,
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
        expandedInsets: widget.padding,
        inputDecorationTheme: InputDecorationTheme(
          suffixIconColor: bohibaTheme.primaryColor,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
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
              item,
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
