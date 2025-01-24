import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:bohiba/component/bohiba_inputfield/currency_inputfield.dart';
import '../../../../component/bohiba_buttons/primary_icon_button.dart';

class CompanyCreateAlert extends StatefulWidget {
  const CompanyCreateAlert({super.key});

  @override
  State<CompanyCreateAlert> createState() => _CompanyCreateAlertState();
}

class _CompanyCreateAlertState extends State<CompanyCreateAlert> {
  final MoneyMaskedTextController minPriceController =
      MoneyMaskedTextController(
          initialValue: 00,
          precision: 2,
          decimalSeparator: ".",
          thousandSeparator: "",
          leftSymbol: "₹");

  final MoneyMaskedTextController maxPriceController =
      MoneyMaskedTextController(
          initialValue: 00,
          precision: 2,
          decimalSeparator: ".",
          thousandSeparator: "",
          leftSymbol: "₹");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.maxFinite,
        height: BohibaResponsiveScreen.height * 0.26,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: 20.0, vertical: BohibaResponsiveScreen.height10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set your price limit",
              style: TextStyle(
                  fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                  color: bohibaTheme.textTheme.displaySmall!.color),
            ),
            Text(
              "We will notify you whenever the price of OMC falls within your specified price range.",
              style: bohibaTheme.textTheme.titleSmall,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: BohibaResponsiveScreen.width * 0.40,
                    child: const Text("Min Amount"),
                  ),
                  SizedBox(
                    width: BohibaResponsiveScreen.width * 0.40,
                    child: const Text("Max Amount"),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: BohibaResponsiveScreen.width * 0.40,
                  child: CurrencyInputField(
                    currencyController: minPriceController,
                  ),
                ),
                const Icon(EvaIcons.minus),
                SizedBox(
                  width: BohibaResponsiveScreen.width * 0.40,
                  child: CurrencyInputField(
                      currencyController: maxPriceController),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PrimaryIconButton(
                onPressed: () {},
                fixedSize: Size(BohibaResponsiveScreen.width * 0.90, 50),
                icon: const Icon(EvaIcons.clockOutline),
                label: "SET ALERT",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
