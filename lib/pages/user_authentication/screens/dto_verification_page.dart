import 'package:flutter/material.dart';
import '../../../component/bohiba_modal/add_vehicle_modal_sheet.dart';
import '/services/user_role_type.dart';
import '/theme/light_theme.dart';
import '/dist/component_exports.dart';
import '../../driver/edit_driver/edit_driver_modal.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bottom_nav_button/bottom_nav_button.dart';

class DtoVerificationPage extends StatefulWidget {
  const DtoVerificationPage({super.key});

  @override
  State<DtoVerificationPage> createState() => _DtoVerificationPageState();
}

class _DtoVerificationPageState extends State<DtoVerificationPage> {
  String? userRole;
  String? requestType;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final Map<dynamic, dynamic> args =
          ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
      debugPrint("\n=============\n| $args |\n=============\n");
      userRole = args["userrole"];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: userRole == UserRoleType.driver
            ? "Liecense Verification"
            : "RC Verification",
      ),
      body: Container(
        width: BohibaResponsiveScreen.width,
        height: BohibaResponsiveScreen.height,
        padding: EdgeInsets.only(
          top: BohibaResponsiveScreen.height20,
          left: BohibaResponsiveScreen.width15,
          right: BohibaResponsiveScreen.width15,
          bottom: BohibaResponsiveScreen.height30,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Insert your document number",
                style: bohibaTheme.textTheme.headlineLarge,
              ),
            ),
            TextInputField(
              hintText: userRole == UserRoleType.driver
                  ? "License Number"
                  : "RC Number",
              textCapitalization: TextCapitalization.characters,
              maxLength: userRole == UserRoleType.driver ? 16 : 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavButton(
        label: userRole == UserRoleType.driver
            ? "Verify License Number"
            : "Verify RC Number",
        onPressed: () {
          if (userRole == UserRoleType.truckOwner) {
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
                return const AddVehicleModalSheet();
              },
            );
          } else if (userRole == UserRoleType.driver) {
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
          }
        },
      ),
    );
  }
}
