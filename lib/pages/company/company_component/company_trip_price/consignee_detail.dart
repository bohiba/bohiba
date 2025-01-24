import 'package:bohiba/dist/component_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class ConsigneeDetails extends StatefulWidget {
  final List<dynamic>? consigneeDetails;
  const ConsigneeDetails({this.consigneeDetails, super.key});

  @override
  State<ConsigneeDetails> createState() => _ConsigneeDetailsState();
}

class _ConsigneeDetailsState extends State<ConsigneeDetails> {
  int isMarkedFav = -1;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: BohibaResponsiveScreen.width15,
        ),
        child: ListView.builder(
          itemCount: 10,
          // physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(bottom: BohibaResponsiveScreen.height10),
                height: BohibaResponsiveScreen.height * 0.12,
                decoration: BoxDecoration(
                  color: bohibaColors.tileColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: BohibaResponsiveScreen.height15,
                        left: BohibaResponsiveScreen.width15,
                        right: BohibaResponsiveScreen.width15,
                      ),
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
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              isMarkedFav = index;

                              setState(() {});
                            },
                            child: SizedBox.fromSize(
                              size: Size(
                                BohibaResponsiveScreen.height30,
                                BohibaResponsiveScreen.height30,
                              ),
                              child: isMarkedFav == index
                                  ? const Icon(
                                      Remix.heart_3_fill,
                                      color: Colors.redAccent,
                                    )
                                  : const Icon(Remix.heart_3_line),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(BohibaResponsiveScreen.width10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
