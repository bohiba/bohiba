import '/component/bohiba_buttons/primary_button.dart';
import '../../component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/component/bohiba_inputfield/date_inputfield.dart';
import '/extensions/bohiba_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/component/bohiba_dropdown_menu/filter_header_widget.dart';
import '/dist/component_exports.dart';

class FilterMenu extends StatefulWidget {
  final bool dateRange;
  final bool status;
  final bool search;
  final String? statusText;
  final String? statusHint;
  final List<String>? statusList;

  /// Creates a customizable filter menu.
  ///
  /// * [dateRange] — show date range filter (default: `true`)
  /// * [status] — show status filter (default: `false`)
  /// * [search] — show keyword search field (default: `false`)
  ///
  /// **NOTE:**
  /// If [status] == `true`, then:
  /// - [statusText] cannot be empty
  /// - [statusList] cannot be null or empty
  /// - [statusHint] cannot be empty
  ///
  /// This rule ensures the status filter is fully functional.
  FilterMenu({
    super.key,
    this.dateRange = true,
    this.status = false,
    this.search = false,
    this.statusText,
    this.statusHint,
    this.statusList,
  }) : assert(
          status == false ||
              (statusList != null && statusList.isNotEmpty) ||
              (statusText != null && statusText.isNotEmpty) ||
              (statusHint != null && statusHint.isNotEmpty),
          'If status is true, statusList and statusHint cannot be null or empty',
        );

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height15,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
            bottom: ScreenUtils.height15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                  color: bohibaTheme.textTheme.bodySmall!.color,
                ),
              ),
              GestureDetector(
                onTap: () => navigatorState.pop(),
                child: Icon(
                  Icons.close,
                  color: bohibaTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 2),

        Padding(
          padding: EdgeInsets.only(
            // top: BohibaResponsiveScreen.height5,
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
            bottom: ScreenUtils.height10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date range
              Visibility(
                visible: widget.dateRange,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterHeaderWidget(
                        onPressTrailing: () {
                          _dateFromController.clear();
                          _dateToController.clear();
                        },
                        title: 'Date Range'),
                    Row(
                      children: [
                        Expanded(
                          child: DateInputField(
                            showPrefixIcon: false,
                            onTap: () async {
                              DateTime? dateTime =
                                  await GlobalService.datePickerModal(
                                context: context,
                              );

                              if (dateTime != null) {
                                _dateFromController.text =
                                    DateFormat('dd-MM-yyyy').format(dateTime);
                              }
                            },
                            controller: _dateFromController,
                            hintText: 'From',
                          ),
                        ),
                        Gap(ScreenUtils.width5),
                        Expanded(
                          child: DateInputField(
                            showPrefixIcon: false,
                            onTap: () async {
                              DateTime? dateTime =
                                  await GlobalService.datePickerModal(
                                      context: context,
                                      startTime: DateFormat('dd-MM-yyyy')
                                          .parse(_dateFromController.text));
                              if (dateTime != null) {
                                _dateToController.text =
                                    DateFormat('dd-MM-yyyy').format(dateTime);
                              }
                            },
                            controller: _dateToController,
                            hintText: 'To',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Activity Type
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    FilterHeaderWidget(
                        onPressTrailing: () {}, title: 'Activity Type'),
                    DropdownButtonFormField<String>(
                      initialValue: 'All warehouses',
                      items: ['All warehouses', 'Warehouse 1', 'Warehouse 2']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {},
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),

              // Status
              Visibility(
                visible: widget.status,
                child: Column(
                  children: [
                    FilterHeaderWidget(
                      onPressTrailing: () {
                        _menuController.clear();
                        setState(() {});
                      },
                      title: widget.statusText ?? '',
                    ),
                    if (widget.status)
                      if (widget.statusList != null ||
                          (widget.statusList?.isNotEmpty ?? false))
                        AppDropdownSearch(
                          menuController: _menuController,
                          items: widget.statusList!,
                          initialValue: widget.statusHint?.toCapitalizedLabel(),
                          hint: 'Select trip status',
                          labelBuilder: (String p1) {
                            return p1.toCapitalizedLabel();
                          },
                        )
                      else
                        SizedBox.shrink()
                  ],
                ),
              ),

              Visibility(
                visible: widget.search,
                child: Column(
                  children: [
                    FilterHeaderWidget(
                        onPressTrailing: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        title: 'Keyword Search'),
                    TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(ScreenUtils.height10),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _dateFromController.clear();
                        _dateToController.clear();
                        _searchController.clear();
                        _menuController.clear();
                        setState(() {});
                      },
                      child: Text(
                        'Reset All',
                        style: TextStyle(color: bohibaTheme.colorScheme.error),
                      ),
                    ),
                  ),
                  Gap(ScreenUtils.width5),
                  Expanded(
                    child: PrimaryButton(
                      height: 15.h,
                      width: ScreenUtils.width / 5,
                      label: 'Apply',
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
