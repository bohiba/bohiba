import 'package:bohiba/component/bohiba_text/bohiba_marquee_text.dart';
import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/model/trip_model.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:bohiba/component/bohiba_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripDocumentSection extends StatelessWidget {
  final List<TripDocument>? documents;
  final void Function(TripDocument document)? onDocumentTap;
  const TripDocumentSection({super.key, this.documents, this.onDocumentTap});

  @override
  Widget build(BuildContext context) {
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
            TripDocument document = documents![index];
            return InkWell(
              onTap: onDocumentTap == null
                  ? null
                  : () {
                      onDocumentTap!(document);
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
                        // imageUrl: null,
                        width: double.infinity,
                        height: ScreenUtils.height * 0.185,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          topRight: Radius.circular(8.r),
                        ),

                        fallbackText: 'NA',
                        applyShortCode: false,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtils.width10,
                        ),
                        child: BohibaMarqueeText(
                          width: ScreenUtils.width,
                          text: document.docType
                                  ?.replaceAll('_', ' ')
                                  .toUpperCase() ??
                              '',
                          overflowText: document.docType
                                  ?.replaceAll('_', ' ')
                                  .toUpperCase() ??
                              '',
                          style: bohibaTheme.textTheme.labelLarge,
                          marqueeTextStyle: bohibaTheme.textTheme.labelLarge,
                          preserFontSize: [
                            bohibaTheme.textTheme.labelLarge!.fontSize!,
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
            crossAxisCount: 2,
            childAspectRatio: 0.855,
            mainAxisSpacing: ScreenUtils.height10,
            crossAxisSpacing: ScreenUtils.width10,
          ),
        ),
      ],
    );
  }
}
