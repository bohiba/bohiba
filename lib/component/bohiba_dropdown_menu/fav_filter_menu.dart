import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '../bohiba_dropdown/primary_dropdown_menu.dart';
import 'filter_header_widget.dart';

class FavFilterMenu extends StatefulWidget {
  const FavFilterMenu({super.key});

  @override
  State<FavFilterMenu> createState() => _FavFilterMenuState();
}

class _FavFilterMenuState extends State<FavFilterMenu> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _favTypeController = TextEditingController();
  String strStatus = 'Driver';

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
              Column(
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
              Gap(ScreenUtils.height15),

              Column(
                children: [
                  // Status
                  FilterHeaderWidget(
                    onPressTrailing: () {
                      strStatus = 'Driver';
                      setState(() {});
                    },
                    title: 'Fav Type',
                  ),

                  PrimaryDropDownMenu(
                    menuController: _favTypeController,
                    width: ScreenUtils.width,
                    hint: "Driver",
                    items: ['Driver', 'Vehicle', 'Company'],
                    dropDownValue: strStatus,
                    onChanged: (value) {},
                  ),
                ],
              ),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _searchController.clear();
                      strStatus = 'Driver';
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
                        fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.bodyMedium!.fontWeight,
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
