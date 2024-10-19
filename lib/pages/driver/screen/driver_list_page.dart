import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/bottom_nav_button/bottom_nav_button.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/driver/add_driver/add_driver_modal.dart';
import 'package:bohiba/pages/driver/edit_driver/edit_driver_modal.dart';
import 'package:bohiba/pages/vehicle/add_vehicle_component/document_tile.dart';
import 'package:bohiba/pages/vehicle/add_vehicle_component/trailing_button.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class DriverListPage extends StatelessWidget {
  const DriverListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TitleAppbar(
        title: 'Drivers',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: BohibaResponsiveScreen.width,
          height: BohibaResponsiveScreen.height,
          child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return const DriverDetaiTile();
              }),
        ),
      ),
      bottomNavigationBar: Material(
        child: Container(
          height: BohibaResponsiveScreen.height * 0.1,
          width: BohibaResponsiveScreen.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: BottomNavButton(
            width: BohibaResponsiveScreen.width * 0.65,
            height: 47,
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                ),
                context: context,
                builder: (BuildContext context) {
                  return const AddNewDriverModalSheet();
                },
              );
            },
            label: "Add New Driver",
          ),
        ),
      ),
    );
  }
}

class DriverDetaiTile extends StatefulWidget {
  const DriverDetaiTile({super.key});

  @override
  State<DriverDetaiTile> createState() => _DriverDetaiTileState();
}

class _DriverDetaiTileState extends State<DriverDetaiTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        child: ExpansionTile(
          backgroundColor: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), side: BorderSide.none),
          textColor: Colors.green,
          leading: CircleAvatar(
            backgroundColor: bohibaColors.primaryVariantColor,
            child: const Icon(Remix.user_4_fill),
          ),
          title: Text(
            '@driverName',
            style: bohibaTheme.textTheme.labelLarge,
          ),
          subtitle: Text(
            'OD14X7224',
            style: bohibaTheme.textTheme.titleMedium,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TrailingButton(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return const EditModalSheet();
                    },
                  );
                },
                icon: Icons.edit,
                iconColor: bohibaColors.primaryColor,
              ),
              const Gap(10),
              TrailingButton(
                onTap: () {},
                icon: Icons.delete,
                iconColor: bohibaColors.warningColor,
              ),
              const Gap(10),
              TrailingButton(
                // onTap: () {},
                icon: isExpanded ? EvaIcons.arrowUp : EvaIcons.arrowDown,
                iconColor: bohibaColors.secoundaryColor,
              ),
            ],
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DocumentTile(
              vehicleDocument: "Mobile Number",
              expiryDate: "+91- 1234 567 890",
            ),
            DocumentTile(
              vehicleDocument: "D.O.B",
              expiryDate: "Jun 28, 2025",
            ),
            DocumentTile(
              vehicleDocument: "Address",
              expiryDate: "8814 Armando Tunnel, Port Peter, IN 89563-0638",
            ),
            DocumentTile(
              vehicleDocument: "License Number",
              expiryDate: "MJPZ1054XX",
              trailing: TextButton(
                onPressed: null,
                child: Text('Renew'),
              ),
            ),
          ],
          onExpansionChanged: (bool expanded) {
            debugPrint("$expanded");
            setState(() {});
            isExpanded = expanded;
          },
        ),
      ),
    );
  }
}
