import 'package:bohiba/component/bohiba_buttons/small_tile_button.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConsigneeDetails extends StatelessWidget {
  final List<dynamic>? consigneeDetails;
  const ConsigneeDetails({this.consigneeDetails, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: BohibaResponsiveScreen.width20),
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 5.0),
                  height: BohibaResponsiveScreen.height * 0.12,
                  decoration: BoxDecoration(
                      color: bohibaColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(
                          BohibaResponsiveScreen.height10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: BohibaResponsiveScreen.height5,
                            horizontal: BohibaResponsiveScreen.width15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: bohibaColors.white,
                            ),
                            Gap(BohibaResponsiveScreen.height10),
                            Text(
                              'company_name',
                              style: bohibaTheme.textTheme.labelMedium,
                            ),
                            /*const Spacer(),
                            SmallTileButton(
                              onTap: () {},
                              label: 'Book',
                            )*/
                          ],
                        ),
                      ),
                      const Divider(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bohibaColors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: const [
                                    TextSpan(text: 'Metal: '),
                                    TextSpan(text: 'Iron'),
                                  ],
                                ),
                              ),
                              Gap(BohibaResponsiveScreen.width15),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bohibaColors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: const [
                                    TextSpan(text: 'Location: '),
                                    TextSpan(text: 'Khandadhar'),
                                  ],
                                ),
                              ),
                              Gap(BohibaResponsiveScreen.width15),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bohibaColors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: const [
                                    TextSpan(text: 'Price: '),
                                    TextSpan(text: '2334.0 /tonne'),
                                  ],
                                ),
                              ),
                              Gap(BohibaResponsiveScreen.width15),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: bohibaColors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                  children: [
                                    const TextSpan(text: 'Wheels: '),
                                    WidgetSpan(
                                      child: Row(
                                        children: List.generate(
                                          4,
                                          (index) => Text(
                                            "${index + 10},",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: bohibaColors.black,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
/*PageView.builder(
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
                  style: bohibaTheme.textTheme.headlineSmall,
                ),
                Text(
                  '₹ ',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight:
                          bohibaTheme.textTheme.headlineMedium!.fontWeight,
                      color: bohibaColors.primaryVariantColor),
                ),
                Gap(25),
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
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                            Text(
                              CompanyScreenString.driverBonus,
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.labelSmall!.fontSize,
                                color:
                                    bohibaTheme.textTheme.displaySmall!.color,
                                fontWeight: bohibaTheme
                                    .textTheme.labelSmall!.fontWeight,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '₹ 1500.00',
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                            Text(CompanyScreenString.fuelBonus,
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.labelSmall!.fontSize,
                                  color:
                                      bohibaTheme.textTheme.displaySmall!.color,
                                  fontWeight: bohibaTheme
                                      .textTheme.labelSmall!.fontWeight,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '12345.76 Ton',
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                            Text(
                              CompanyScreenString.availableMaterial,
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.labelSmall!.fontSize,
                                color:
                                    bohibaTheme.textTheme.displaySmall!.color,
                                fontWeight: bohibaTheme
                                    .textTheme.labelSmall!.fontWeight,
                              ),
                            ),
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
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                            Text(CompanyScreenString.materialType,
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.labelSmall!.fontSize,
                                  color:
                                      bohibaTheme.textTheme.displaySmall!.color,
                                  fontWeight: bohibaTheme
                                      .textTheme.labelSmall!.fontWeight,
                                )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '12345.76 Tonne',
                              style: bohibaTheme.textTheme.labelLarge,
                            ),
                            Text(
                              CompanyScreenString.transportTo,
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.labelSmall!.fontSize,
                                color:
                                    bohibaTheme.textTheme.displaySmall!.color,
                                fontWeight: bohibaTheme
                                    .textTheme.labelSmall!.fontWeight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ) */
