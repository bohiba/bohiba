import 'package:bohiba/component/bohiba_text/bohiba_marquee_text.dart';
import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/extensions/bohiba_extension.dart';
import 'package:bohiba/model/trip_model.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
              child: Container(
                decoration: BoxDecoration(
                  color: bohibaTheme.cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: ScreenUtils.height * 0.185,
                      decoration: BoxDecoration(
                        color: bohibaTheme.dividerColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          topRight: Radius.circular(8.r),
                        ),
                      ),
                      child: document.image == null
                          ? null
                          : ClipRRect(
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(8.r),
                                topRight: Radius.circular(8.r),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: '${ImagePath.tripImage}/${document.image}',
                                height: ScreenUtils.height * 0.185,
                                width: ScreenUtils.width,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade200,
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: bohibaTheme.dividerColor,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtils.width10,
                        vertical: ScreenUtils.width10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BohibaMarqueeText(
                            width: ScreenUtils.width,
                            text: document.docType?.toCapitalizedLabel() ?? '',
                            overflowText: document.docType?.toCapitalizedLabel() ?? '',
                            style: bohibaTheme.textTheme.bodySmall,
                            marqueeTextStyle: bohibaTheme.textTheme.bodySmall,
                            preserFontSize: [
                              bohibaTheme.textTheme.bodySmall!.fontSize!,
                            ],
                          ),
                          BohibaMarqueeText(
                            width: ScreenUtils.width,
                            text: document.updatedAt ?? '',
                            overflowText: document.updatedAt ?? '',
                            style: bohibaTheme.textTheme.titleMedium,
                            marqueeTextStyle: bohibaTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.82,
            mainAxisSpacing: ScreenUtils.height10,
            crossAxisSpacing: ScreenUtils.width10,
          ),
        ),
      ],
    );
  }
}
