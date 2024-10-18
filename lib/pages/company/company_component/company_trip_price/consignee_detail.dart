import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/pages/company/company_string/company_string.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_colors.dart';

class ConsigneeDetails extends StatelessWidget {
  final List<dynamic> consigneeDetails;
  const ConsigneeDetails({required this.consigneeDetails, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: BohibaResponsiveScreen.width * 0.95,
        height: BohibaResponsiveScreen.height * 0.50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(
            BohibaResponsiveScreen.width10,
          ),
        ),
        child: PageView.builder(
            itemCount: consigneeDetails.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var loadDetails = consigneeDetails[index];
              debugPrint(loadDetails.toString());
              return Container(
                width: BohibaResponsiveScreen.width * 0.95,
                height: BohibaResponsiveScreen.height * 0.50,
                padding: EdgeInsets.zero,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      CompanyScreenString.transportPrice,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '₹ ',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontWeight,
                          color: bohibaColors.primaryVariantColor),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹ 2000.00',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(CompanyScreenString.driverBonus,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .color,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontWeight,
                                    )),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '₹ 1500.00',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(CompanyScreenString.fuelBonus,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .color,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontWeight,
                                    )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '12345.76 Ton',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(CompanyScreenString.availableMaterial,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .color,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontWeight,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Iron',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(CompanyScreenString.materialType,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .color,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontWeight,
                                    )),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '12345.76 Tonne',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(CompanyScreenString.transportTo,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .color,
                                      fontWeight: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontWeight,
                                    )),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
