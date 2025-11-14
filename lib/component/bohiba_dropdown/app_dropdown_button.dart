import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdown<T> extends FormField<T> {
  AppDropdown({
    super.key,
    required List<T> items,
    required String Function(T) labelBuilder,
    super.initialValue,
    ValueChanged<T?>? onChanged,
    super.validator,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
    String? hint,
    bool enableSearch = false,
    bool requestFocusOnTap = false,
    TextEditingController? menuController,
    bool showIcon = true,
    double? width,
    double? menuHeight,
    EdgeInsets? padding,
  }) : super(
          builder: (FormFieldState<T> field) {
            final state = field as _AppDropdownFormFieldState<T>;
            final errorText = state.errorText;

            return Container(
              width: width ?? double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: DropdownMenu<T>(
                width: width,
                initialSelection: state.value,
                controller: menuController,
                requestFocusOnTap: requestFocusOnTap,
                enableFilter: enableSearch,
                hintText: hint,
                errorText: errorText,
                menuHeight: menuHeight ?? 250,
                textStyle: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                  letterSpacing: 1.2,
                ),
                trailingIcon: showIcon == true
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: bohibaTheme.dividerColor,
                      )
                    : Container(),
                selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  isCollapsed: true,
                  suffixIconColor: bohibaTheme.primaryColor,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 15.w),
                ),
                expandedInsets:
                    padding ?? EdgeInsets.symmetric(vertical: 5.0.h),
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
                        fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                        fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                        color: bohibaTheme.textTheme.titleLarge!.color,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                }).toList(),
                onSelected: (value) {
                  field.didChange(value);
                  onChanged?.call(value);
                },
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T> extends FormFieldState<T> {
  @override
  void didUpdateWidget(FormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

/*class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? dropDownValue;
  final void Function(T?)? onChanged;
  final String Function(T) labelBuilder;
  final bool showIcon;
  final double? width;
  final double? height;
  final double? menuHeight;
  final String? errorText;
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
    this.errorText,
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
  DropdownMenuFormField<T> get _dropdownMenuFormField =>
      widget as DropdownMenuFormField<T>;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.height ?? 47,
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
        errorText: widget.errorText,
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
          isDense: true,
          isCollapsed: true,
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
*/
