import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/dist/enums/enum_search_state.dart';

import '/theme/bohiba_theme.dart';
import '/component/bohiba_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownSearch<T> extends FormField<T> {
  AppDropdownSearch({
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
    EnumSearchState? searchState,
    void Function(String query)? onSearchChanged,
    String? searchErrorMessage,
  }) : super(
          builder: (FormFieldState<T> field) {
            if (searchState != null) {
              return _AsyncSearchDropdownContent<T>(
                fieldState: field,
                searchState: searchState,
                items: items,
                labelBuilder: labelBuilder,
                onChanged: onChanged,
                onSearchChanged: onSearchChanged,
                menuController: menuController,
                hint: hint,
                width: 10,
                padding: padding,
                searchErrorMessage: searchErrorMessage,
              );
            }

            final state = field as _AppDropdownFormFieldState<T>;
            final errorText = state.errorText;

            return Container(
              width: width ?? double.infinity,
              margin: padding,
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
                        color: bohibaTheme.inputDecorationTheme.enabledBorder!
                            .borderSide.color,
                      )
                    : Container(),
                selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
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

class _AsyncSearchDropdownContent<T> extends StatefulWidget {
  const _AsyncSearchDropdownContent({
    super.key,
    required this.fieldState,
    required this.searchState,
    required this.items,
    required this.labelBuilder,
    this.onChanged,
    this.onSearchChanged,
    this.menuController,
    this.hint,
    this.width,
    this.padding,
    this.searchErrorMessage,
  });

  final FormFieldState<T> fieldState;
  final EnumSearchState searchState;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?>? onChanged;
  final void Function(String query)? onSearchChanged;

  final TextEditingController? menuController;
  final String? hint;
  final double? width;
  final EdgeInsets? padding;
  final String? searchErrorMessage;

  @override
  State<_AsyncSearchDropdownContent<T>> createState() =>
      _AsyncSearchDropdownContentState<T>();
}

class _AsyncSearchDropdownContentState<T>
    extends State<_AsyncSearchDropdownContent<T>> {
  late final TextEditingController _inputController;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  double _overlayWidth = 300;

  @override
  void initState() {
    super.initState();
    // Pre-populate the text field when editing an existing record.
    final initial = widget.fieldState.value;
    _inputController = TextEditingController(
      text: initial != null ? widget.labelBuilder(initial) : '',
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    final errorText = widget.fieldState.errorText;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ScreenUtils.width * 0.95,
            margin: widget.padding ?? EdgeInsets.symmetric(vertical: 5.h),
            child: TextField(
              controller: _inputController,
              focusNode: _focusNode,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                color: bohibaTheme.textTheme.bodyLarge!.color,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                suffixIcon: _focusNode.hasPrimaryFocus
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.close,
                            size: 18.r, color: BohibaColors.greyColor),
                        onPressed: () {
                          _inputController.clear();
                          widget.menuController?.clear();

                          widget.fieldState.didChange(null);
                          widget.onChanged?.call(null);
                          widget.onSearchChanged?.call('');

                          _removeOverlay();
                          _focusNode.unfocus();

                          if (mounted) {
                            setState(() {});
                          }
                        },
                      )
                    : Icon(Icons.search),
                border: bohibaTheme.inputDecorationTheme.border,
                enabledBorder: bohibaTheme.inputDecorationTheme.enabledBorder,
                focusedBorder: bohibaTheme.inputDecorationTheme.focusedBorder,
                focusedErrorBorder:
                    bohibaTheme.inputDecorationTheme.focusedErrorBorder,
                errorBorder: bohibaTheme.inputDecorationTheme.errorBorder,
                errorText: errorText,
                errorMaxLines: 1,
              ),
              onChanged: (value) {
                widget.onSearchChanged?.call(value);
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(_AsyncSearchDropdownContent<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchState != widget.searchState ||
        oldWidget.items.length != widget.items.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _overlayEntry?.markNeedsBuild();
        }
      });
    }

    final newValue = widget.fieldState.value;
    if (newValue != null && !_focusNode.hasFocus) {
      final newLabel = widget.labelBuilder(newValue);

      if (_inputController.text != newLabel) {
        _inputController.text = newLabel;
      }
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 150), _removeOverlay);
    }
    setState(() {});
  }

  void _showOverlay() {
    _removeOverlay();
    // Capture the current widget width for the overlay panel.
    final renderBox = context.findRenderObject() as RenderBox;

    _overlayWidth = renderBox.size.width;
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      canSizeOverlay: false,
      builder: (_) => Positioned(
        width: _overlayWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          child: Material(
            elevation: 0.85,
            borderRadius: BorderRadius.circular(8.r),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250.h,
              ),
              child: _buildDropdownContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownContent() {
    switch (widget.searchState) {
      case EnumSearchState.idle:
        return _buildIdle();
      case EnumSearchState.searching:
        return _buildSearching();
      case EnumSearchState.noDataFound:
        return _buildNoData();
      case EnumSearchState.error:
        return _buildError();
      case EnumSearchState.success:
        return _buildResults();
    }
  }

  Widget _buildIdle() {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Text(
        'Type to search…',
        style: TextStyle(
          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
          color: BohibaColors.greyColor,
        ),
      ),
    );
  }

  Widget _buildSearching() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: SizedBox(
          width: 22.r,
          height: 22.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: bohibaTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
            color: BohibaColors.greyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Text(
          widget.searchErrorMessage ?? 'Something went wrong. Try again.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
            color: BohibaColors.warningColor,
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (widget.items.isEmpty) return _buildNoData();

    // Use label-based equality so we don't require T to override ==.
    final selectedLabel = widget.fieldState.value != null
        ? widget.labelBuilder(widget.fieldState.value as T)
        : null;

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (_, index) {
        final item = widget.items[index];
        final label = widget.labelBuilder(item);
        final isSelected = selectedLabel != null && selectedLabel == label;

        return InkWell(
          onTap: () {
            // 1. Update the visible text field.
            _inputController.text = label;
            // 2. Keep the external menuController in sync.
            widget.menuController?.text = label;
            // 3. Notify the FormField so validation and form submission work.
            widget.fieldState.didChange(item);
            // 4. Notify the parent (controller).
            widget.onChanged?.call(item);
            // 5. Close the overlay.
            _focusNode.unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            color: isSelected
                ? bohibaTheme.primaryColor.withValues(alpha: 0.08)
                : null,
            child: Text(
              label,
              style: TextStyle(
                fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                color: isSelected
                    ? bohibaTheme.primaryColor
                    : bohibaTheme.textTheme.titleLarge!.color,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _inputController.dispose();
    _removeOverlay();
    super.dispose();
  }
}
