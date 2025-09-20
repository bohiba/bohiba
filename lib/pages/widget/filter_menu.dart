import '/component/bohiba_dropdown/primary_dropdown_menu.dart';
import '/dist/controller_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/component/bohiba_dropdown_menu/filter_header_widget.dart';
import '/dist/component_exports.dart';

class FilterMenu extends StatefulWidget {
  final bool dateRange;
  final bool status;
  final bool search;
  const FilterMenu(
      {super.key,
      this.dateRange = true,
      this.status = true,
      this.search = true});

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _menuController = TextEditingController();
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
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
            bottom: ScreenUtils.height10,
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
                                  await GlobalService.pickDate(
                                context: context,
                                dateFormatter: 'dd-MM-yyyy',
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
                        SizedBox(width: ScreenUtils.width5),
                        Expanded(
                          child: TextFormField(
                            onTap: () async {
                              _dateToController.text =
                                  await GlobalService.pickDate(
                                context: context,
                                dateFormatter: 'dd-MM-yyyy',
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
                      title: 'Status',
                    ),

                    PrimaryDropDownMenu(
                      menuController: _menuController,
                      width: ScreenUtils.width,
                      hint: "Booked",
                      items: ['Booked', 'Sucessful', 'Cancelled'],
                      dropDownValue: 'Driver',
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
              Gap(ScreenUtils.height15),

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
                        style: TextStyle(color: BohibaColors.warningColor)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply Now',
                      style: TextStyle(
                        color: BohibaColors.white,
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
