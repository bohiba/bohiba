import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_modal/add_vehicle_modal_sheet.dart';
import '/services/user_role_type.dart';
import '/dist/component_exports.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bottom_nav_button/bottom_nav_button.dart';

class DtoVerificationPage extends StatefulWidget {
  const DtoVerificationPage({super.key});

  @override
  State<DtoVerificationPage> createState() => _DtoVerificationPageState();
}

class _DtoVerificationPageState extends State<DtoVerificationPage> {
  int? userRole;
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
        title: userRole == UserRoles.driver
            ? "Liecense Verification"
            : "RC Verification",
      ),
      body: Container(
        width: ScreenUtils.width,
        height: ScreenUtils.height,
        padding: EdgeInsets.only(
          top: ScreenUtils.height20,
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
          bottom: ScreenUtils.height30,
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
              hintText:
                  userRole == UserRoles.driver ? "License Number" : "RC Number",
              textCapitalization: TextCapitalization.characters,
              maxLength: userRole == UserRoles.driver ? 16 : 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavButton(
        label: userRole == UserRoles.driver
            ? "Verify License Number"
            : "Verify RC Number",
        onPressed: () {
          if (userRole == UserRoles.truckOwner) {
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
          } else if (userRole == UserRoles.driver) {
            // showModalBottomSheet(
            //   isScrollControlled: true,
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(12.0),
            //       topLeft: Radius.circular(12.0),
            //     ),
            //   ),
            //   context: context,
            //   builder: (context) {
            //     return const EditDriverDetialsModalSheet();
            //   },
            // );
          }
        },
      ),
    );
  }
}
