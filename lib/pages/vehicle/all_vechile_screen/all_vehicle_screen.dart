import 'package:bohiba/pages/vehicle/add_vehicle_component/driver_details_component.dart';
import 'package:bohiba/pages/vehicle/add_vehicle_component/trailing_button.dart';
import 'package:bohiba/pages/vehicle/add_vehicle_component/vehicle_doc_component.dart';
import 'package:bohiba/pages/vehicle/add_vehicle_widget/edit_vehicle_modal_sheet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';

import '../../../utils/bottom_nav_button/bottom_nav_button.dart';
import '../../../utils/bohiba_appbar/add_vehicle_appbar.dart';
import '../add_vehicle_widget/add_vehicle_modal_sheet.dart';

class AllVehicleScreen extends StatefulWidget {
  const AllVehicleScreen({Key? key}) : super(key: key);

  @override
  State<AllVehicleScreen> createState() => _AddVehiclepagestate();
}

class _AddVehiclepagestate extends State<AllVehicleScreen> {
  bool customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const AddVehicleAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Column(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Card(
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
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return Dialog(
                            //         insetPadding: const EdgeInsets.symmetric(
                            //           vertical: 10.0,
                            //           horizontal: 15.0,
                            //         ),
                            //         child: Container(
                            //           height: height * 0.36,
                            //           padding: const EdgeInsets.symmetric(
                            //             vertical: 10.0,
                            //             horizontal: 15.0,
                            //           ),
                            //           child: Column(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.centerLeft,
                            //                 child: Text(
                            //                   'Edit Driver info',
                            //                   style: Theme.of(context)
                            //                       .textTheme
                            //                       .headlineMedium,
                            //                 ),
                            //               ),
                            //               const Gap(10.0),
                            //               const TextInputField(
                            //                 hintText: 'DL Number',
                            //               ),
                            //               const TextInputField(
                            //                 hintText: 'Name',
                            //               ),
                            //               const TextInputField(
                            //                 maxLength: 10,
                            //                 keyboardType: TextInputType.phone,
                            //                 hintText: 'Mobile Number',
                            //               ),
                            //               PrimaryButton(
                            //                 onPressed: () {},
                            //                 label: 'SUBMIT',
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     });
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
                    children: const [
                      VehicleDocuments(
                        vehicleDocument: "Engine Number",
                        expiryDate: "MJPZ1054XX",
                      ),
                      VehicleDocuments(
                        vehicleDocument: "Chassis Number",
                        expiryDate: "MB1KJLHD5MPJXXXXX",
                      ),
                      VehicleDocuments(
                        vehicleDocument: "Vehicle Insurance",
                        expiryDate: "26/07/2027",
                        trailing: TextButton(
                          onPressed: null,
                          child: Text("Renew"),
                        ),
                      ),
                      VehicleDocuments(
                        vehicleDocument: "Permit",
                        expiryDate: "01/02/2027",
                        trailing: TextButton(
                          onPressed: null,
                          child: Text("Renew"),
                        ),
                      ),
                      VehicleDocuments(
                        vehicleDocument: "Fitness Certificate",
                        expiryDate: "01/02/2027",
                        trailing: TextButton(
                          onPressed: null,
                          child: Text("Renew"),
                        ),
                      ),
                      DriverDetailTile(),
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
      bottomNavigationBar: Material(
        child: Container(
          height: height * 0.1,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: BottomNavButton(
            width: width * 0.65,
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
                  return const AddVehicleModalSheet();
                },
              );
            },
            label: "Add Vehicle",
          ),
        ),
      ),
    );
  }
}
