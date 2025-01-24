import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../dist/component_exports.dart';
import '../../theme/light_theme.dart';

class SortMenu extends StatefulWidget {
  final bool dateSort;
  const SortMenu({super.key, this.dateSort = false});

  @override
  State<SortMenu> createState() => _SortMenuState();
}

class _SortMenuState extends State<SortMenu> {
  int dateIndex = 0;
  int activityIndex = 0;
  int nameIndex = 0;

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
                'Sort by',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
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
        // Sort by Date
        Padding(
          padding: EdgeInsets.only(
            left: BohibaResponsiveScreen.width15,
            right: BohibaResponsiveScreen.width15,
            bottom: BohibaResponsiveScreen.height10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.dateSort,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SortHeaderWidget(
                      title: 'Date',
                    ),
                    _SortOption(
                      options: ['Ascending', 'Descending'],
                      selectedIndex: dateIndex,
                      onChanged: (p0) {
                        dateIndex = p0!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),

              // Sort by Activity
              _SortHeaderWidget(
                title: 'Activity',
              ),
              _SortOption(
                options: ['A-Z', 'Z-A'],
                selectedIndex: activityIndex,
                onChanged: (index) {
                  activityIndex = index ?? 0;
                  setState(() {});
                },
              ),
              // Sort by Name
              _SortHeaderWidget(
                title: 'Name',
              ),
              _SortOption(
                options: ['A-Z', 'Z-A'],
                selectedIndex: nameIndex,
                onChanged: (p0) {
                  nameIndex = p0 ?? 0;
                  setState(() {});
                },
              ),
              Gap(BohibaResponsiveScreen.height15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      'Reset All',
                      style: TextStyle(color: bohibaColors.primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Apply Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Buttons
      ],
    );
  }
}

class _SortHeaderWidget extends StatelessWidget {
  final String title;
  const _SortHeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: BohibaResponsiveScreen.height10),
      child: Text(title, style: bohibaTheme.textTheme.titleMedium),
    );
  }
}

class _SortOption extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int?)? onChanged;

  const _SortOption(
      {required this.options, required this.selectedIndex, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.asMap().entries.map(
        (entry) {
          int index = entry.key;
          String option = entry.value;
          return RadioListTile(
            value: index,
            groupValue: selectedIndex,
            selectedTileColor: bohibaColors.primaryVariantColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
            tileColor: bohibaColors.bgColor,
            activeColor: bohibaColors.primaryColor,
            title: Text(option, style: bohibaTheme.textTheme.titleMedium),
            onChanged: onChanged,
          );
        },
      ).toList(),
    );
  }
}
