import 'package:bohiba/component/bohiba_appbar/load_appbar.dart';
import 'package:bohiba/component/bohiba_buttons/utility_action_button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../dist/widget_exports.dart';

class AllLoadScreen extends StatelessWidget {
  const AllLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LoadAppBar(
        title: 'Loads',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UtilityActionButton(
                  onPanDown: (tapDownDetails) => showMenu(
                    context: context,
                    menuPadding: EdgeInsets.zero,
                    position: RelativeRect.fromLTRB(
                      tapDownDetails.localPosition.dx,
                      tapDownDetails.localPosition.dy + 140,
                      0,
                      tapDownDetails.localPosition.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        enabled: false,
                        child: SortMenu(),
                      )
                    ],
                  ),
                  icon: Remix.arrow_up_down_line,
                  buttonName: 'Sort',
                ),
                UtilityActionButton(
                  onPanDown: (tapDownDetails) => showMenu(
                    context: context,
                    menuPadding: EdgeInsets.zero,
                    position: RelativeRect.fromLTRB(
                      tapDownDetails.localPosition.dx,
                      tapDownDetails.localPosition.dy + 140,
                      0,
                      tapDownDetails.localPosition.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        enabled: false,
                        child: FilterMenu(),
                      )
                    ],
                  ),
                  icon: Remix.equalizer_2_line,
                  buttonName: 'Filter',
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('C-1'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(EvaIcons.diagonalArrowRightUp),
                    ),
                    Text('C-1')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
