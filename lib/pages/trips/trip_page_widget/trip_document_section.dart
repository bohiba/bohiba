import 'package:bohiba/component/bohiba_text/bohiba_marquee_text.dart';
import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/controllers/trip_controller.dart';
import 'package:bohiba/model/trip_model.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:bohiba/component/bohiba_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TripDocumentSection extends StatelessWidget {
  final TripController controller;
  const TripDocumentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<TripDocument>? documents = controller.tripInfo.value?.documents;
      if (documents?.isEmpty ?? true) return SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height25,
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
            ),
            child: Text(
              'Documents',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: ScreenUtils.height10,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
              bottom: ScreenUtils.height20,
            ),
            itemCount: documents?.length,
            itemBuilder: (context, index) {
              TripDocument? document = documents?[index];
              if (document == null) return SizedBox.shrink();
              return InkWell(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      insetPadding:
                          EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: BohibaNetworkImage.rounded(
                        imageUrl: '${ImagePath.tripImage}/${document.image}',
                        width: ScreenUtils.width,
                        height: ScreenUtils.height * 0.8,
                        // borderRadius: BorderRadius.circular(8.r),
                        fallbackText: '',
                        applyShortCode: false,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 0.15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BohibaNetworkImage(
                          imageUrl: '${ImagePath.tripImage}/${document.image}',
                          width: double.infinity,
                          height: ScreenUtils.height * 0.095,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.r),
                            topRight: Radius.circular(8.r),
                          ),
                          fallbackText: '',
                          applyShortCode: false,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtils.width10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BohibaMarqueeText(
                                width: ScreenUtils.width50,
                                text: document.docType
                                        ?.replaceAll('_', ' ')
                                        .toUpperCase() ??
                                    '',
                                overflowText: document.docType
                                        ?.replaceAll('_', ' ')
                                        .toUpperCase() ??
                                    '',
                                style: bohibaTheme.textTheme.bodySmall,
                                marqueeTextStyle:
                                    bohibaTheme.textTheme.bodySmall,
                                preserFontSize: [
                                  bohibaTheme.textTheme.bodySmall!.fontSize!,
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  int success = await controller.deleteDocument(
                                      docId: document.id!);
                                  if (success > 0) {
                                    await controller.getTripInfo(
                                        id: controller.tripInfo.value!.id!);
                                  }
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 16.w,
                                  color: bohibaTheme.colorScheme.tertiary,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: ScreenUtils.width5,
              crossAxisSpacing: ScreenUtils.width5,
            ),
          ),
        ],
      );
    });
  }
}
