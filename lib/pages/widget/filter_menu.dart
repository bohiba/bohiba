import 'package:bohiba/dist/controller_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../dist/component_exports.dart';

class FilterMenu extends StatefulWidget {
  final bool dateRange;
  final bool status;
  final bool search;
  const FilterMenu(
      {super.key,
      this.dateRange = false,
      this.status = false,
      this.search = false});

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final GlobalController _globalController = Get.put(GlobalController());
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String strStatus = 'Booked';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.only(
            top: BohibaResponsiveScreen.height15,
            left: BohibaResponsiveScreen.width15,
            right: BohibaResponsiveScreen.width15,
            bottom: BohibaResponsiveScreen.height15,
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
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close),
              ),
            ],
          ),
        ),
        Divider(thickness: 1.0, height: 0),
        // Date Range
        Padding(
          padding: EdgeInsets.only(
            // top: BohibaResponsiveScreen.height5,
            left: BohibaResponsiveScreen.width15,
            right: BohibaResponsiveScreen.width15,
            bottom: BohibaResponsiveScreen.height10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          child: TextFormField(
                            onTap: () async {
                              _dateFromController.text =
                                  await _globalController.pickDate(
                                dateFormatter: DateFormat('dd-MM-yyyy'),
                                hintText: 'Start Form',
                              );
                            },
                            controller: _dateFromController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'From',
                              // suffixIcon: Icon(Icons.calendar_today, size: 14),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: BohibaResponsiveScreen.width5),
                        Expanded(
                          child: TextFormField(
                            onTap: () async {
                              _dateToController.text =
                                  await _globalController.pickDate(
                                dateFormatter: DateFormat('dd-MM-yyyy'),
                                hintText: 'Start Form',
                              );
                            },
                            controller: _dateToController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'To',
                              // suffixIcon: Icon(Icons.calendar_today, size: 14),
                              border: OutlineInputBorder(),
                            ),
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
                      value: 'All warehouses',
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

              Visibility(
                visible: widget.status,
                child: Column(
                  children: [
                    // Status
                    FilterHeaderWidget(
                        onPressTrailing: () {
                          strStatus = 'Booked';
                          setState(() {});
                        },
                        title: 'Status'),
                    DropdownButtonFormField<String>(
                      value: strStatus,
                      items: ['Booked', 'Load', 'Completed', 'Cancelled']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          strStatus = value!;
                        });
                      },
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
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
              Gap(BohibaResponsiveScreen.height15),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _dateFromController.clear();
                      _dateToController.clear();
                      _searchController.clear();
                      strStatus = 'Booked';
                      setState(() {});
                    },
                    child: Text('Reset All',
                        style: TextStyle(color: bohibaColors.warningColor)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply Now',
                      style: TextStyle(
                        color: bohibaColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class FilterHeaderWidget extends StatelessWidget {
  final VoidCallback onPressTrailing;
  final String title;
  const FilterHeaderWidget({
    super.key,
    required this.onPressTrailing,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: BohibaResponsiveScreen.height15,
          bottom: BohibaResponsiveScreen.height10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                color: bohibaTheme.textTheme.bodySmall!.color),
          ),
          GestureDetector(
            onTap: onPressTrailing,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
