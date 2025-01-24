import 'package:bohiba/component/bohiba_navbar/helper_navbar/helper_navbar.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:get/get.dart';

import 'user_address_auth_page.dart';
import 'user_bank_auth_screen.dart';
import 'user_document_auth_screen.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Theme(
          data: ThemeData(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(primary: bohibaColors.primaryColor),
              primaryColor: bohibaColors.primaryColor,
              canvasColor: bohibaColors.white,
              inputDecorationTheme: Theme.of(context).inputDecorationTheme),
          child: Stepper(
            connectorThickness: 1.5,
            type: StepperType.horizontal,
            elevation: 0,
            steps: [
              Step(
                isActive: _currentStep == 0 ? true : false,
                state:
                    _currentStep >= 0 ? StepState.indexed : StepState.disabled,
                title: const Text('Document'),
                content: const UserDocAuthScreen(),
              ),
              Step(
                isActive: _currentStep == 1 ? true : false,
                state:
                    _currentStep >= 0 ? StepState.indexed : StepState.disabled,
                title: const Text('Address'),
                content: const UserAddressAuthPage(),
              ),
              Step(
                isActive: _currentStep == 2 ? true : false,
                state:
                    _currentStep >= 0 ? StepState.indexed : StepState.disabled,
                title: const Text('Bank'),
                content: const UserBankAuthScreen(),
              ),
            ],
            onStepContinue: () {
              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
            },
            onStepCancel: () {
              _currentStep <= 2 ? setState(() => _currentStep--) : null;
            },
            onStepTapped: (int index) {
              setState(
                () => _currentStep = index,
              );
            },
            currentStep: _currentStep,
            controlsBuilder: (context, controlsDetails) {
              return const SizedBox();
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _currentStep > 0 && _currentStep <= 2
                ? InkWell(
                    radius: 40,
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      _currentStep <= 2 ? setState(() => _currentStep--) : null;
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: bohibaColors.lightGreyColor,
                      child: const Icon(
                        EvaIcons.arrowIosBackOutline,
                        size: 36,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 30,
                    backgroundColor: bohibaColors.transparent,
                  ),
            _currentStep == 2
                ? GestureDetector(
                    onTap: () => Get.toNamed(
                      AppRoute.navBar,
                      arguments: {
                        HelperNavBar.currentIndex: 0,
                      },
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: bohibaColors.lightGreyColor,
                      child: const Icon(
                        EvaIcons.saveOutline,
                        size: 36,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _currentStep < 2 ? setState(() => _currentStep++) : null;
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: bohibaColors.lightGreyColor,
                      child: const Icon(
                        EvaIcons.arrowIosForwardOutline,
                        size: 36,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
