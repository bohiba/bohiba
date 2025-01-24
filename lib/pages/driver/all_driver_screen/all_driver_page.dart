import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/services/user_role_type.dart';

import '/dist/component_exports.dart';
import '/pages/driver/edit_driver/edit_driver_modal.dart';
import '/pages/vehicle/add_vehicle_component/document_tile.dart';
import '/pages/vehicle/add_vehicle_component/trailing_button.dart';
import '/theme/light_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class AllDriverPage extends StatelessWidget {
  const AllDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Drivers',
        actions: [
          AppBarIconBox(
            icon: const Icon(EvaIcons.plus),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.dtoAuthScreen,
                arguments: {
                  "userrole": UserRoleType.driver.toLowerCase(),
                },
              );
              /*showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                ),
                backgroundColor: bohibaColors.bgColor,
                context: context,
                builder: (BuildContext context) {
                  return const AddNewDriverModalSheet();
                },
              );*/
            },
          )
        ],
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: BohibaResponsiveScreen.width15),
        child: SizedBox(
          width: BohibaResponsiveScreen.width,
          height: BohibaResponsiveScreen.height,
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return const DriverDetaiTile();
              }),
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
        color: bohibaColors.tileColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        child: ExpansionTile(
          backgroundColor: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), side: BorderSide.none),
          textColor: Colors.green,
          leading: CircleAvatar(
            backgroundColor: bohibaColors.primaryVariantColor,
            child: const Icon(Remix.user_4_fill),
          ),
          title: Text(
            'Name',
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
                        topRight: Radius.circular(12.0),
                        topLeft: Radius.circular(12.0),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return const EditDriverDetialsModalSheet();
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
