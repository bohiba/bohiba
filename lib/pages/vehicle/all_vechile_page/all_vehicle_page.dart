import 'package:bohiba/services/user_role_type.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/routes/bohiba_route.dart';
import '/pages/vehicle/add_vehicle_component/driver_details_component.dart';
import '/pages/vehicle/add_vehicle_component/trailing_button.dart';
import '/pages/vehicle/add_vehicle_component/document_tile.dart';
import '/component/bohiba_modal/edit_vehicle_modal_sheet.dart';
import '/dist/component_exports.dart';

class AllVehicleScreen extends StatefulWidget {
  const AllVehicleScreen({super.key});

  @override
  State<AllVehicleScreen> createState() => _AddVehiclepagestate();
}

class _AddVehiclepagestate extends State<AllVehicleScreen> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: "Vehicles",
        actions: [
          AppBarIconBox(
            icon: const Icon(EvaIcons.plus),
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.dtoAuthScreen,
                arguments: {
                  "userrole": UserRoleType.truckOwner.toLowerCase(),
                  "request_type": ""
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
                context: context,
                builder: (BuildContext context) {
                  return const AddVehicleModalSheet();
                },
              );*/
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Column(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Card(
                  elevation: 0,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ExpansionTile(
                    backgroundColor: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide.none),
                    textColor: Colors.green,
                    title: Text(
                      'OD 14X 7224',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    subtitle: Text(
                      'ASHOK LEYLAND LTD',
                      style: Theme.of(context).textTheme.titleMedium,
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
                                return const EditVechileDetailsModalSheet();
                              },
                            );
                          },
                          icon: Icons.edit,
                          iconColor: bohibaColors.primaryColor,
                        ),
                        const SizedBox(width: 10),
                        TrailingButton(
                          onTap: () {},
                          icon: Icons.delete,
                          iconColor: bohibaColors.warningColor,
                        ),
                        const SizedBox(width: 10),
                        TrailingButton(
                          icon: EvaIcons.arrowDown,
                          iconColor: bohibaColors.secoundaryColor,
                        ),
                      ],
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DocumentTile(
                        vehicleDocument: "Engine Number",
                        expiryDate: "MJPZ1054XX",
                      ),
                      DocumentTile(
                        vehicleDocument: "Chassis Number",
                        expiryDate: "MB1KJLHD5MPJXXXXX",
                      ),
                      DocumentTile(
                        vehicleDocument: "Vehicle Insurance",
                        expiryDate: "26/07/2027",
                        trailing: TextButton(
                          onPressed: null,
                          child: Text("Renew"),
                        ),
                      ),
                      DocumentTile(
                        vehicleDocument: "Permit",
                        expiryDate: "01/02/2027",
                        trailing: TextButton(
                          onPressed: null,
                          child: Text("Renew"),
                        ),
                      ),
                      DocumentTile(
                        vehicleDocument: "Fitness Certificate",
                        expiryDate: "01/02/2027",
                        trailing: TextButton(
                          onPressed: null,
                          child: Text("Renew"),
                        ),
                      ),
                      DriverDetailTile(),
                      Gap(BohibaResponsiveScreen.height15),
                    ],
                    onExpansionChanged: (bool expanded) {
                      setState(
                        () {
                          customTileExpanded = expanded;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
