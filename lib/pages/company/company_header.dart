import 'package:auto_size_text/auto_size_text.dart';
import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/model/company_model.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CompanyHeader extends StatelessWidget {
  final CompanyModel? minesModel;
  const CompanyHeader({super.key, required this.minesModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtils.height15),
          child: Row(
            children: [
              if (minesModel?.logo == null ||
                  (minesModel?.logo?.isEmpty ?? true))
                CircleAvatar(
                  radius: 20,
                  backgroundColor: bohibaTheme.colorScheme.surface,
                  child: AutoSizeText(
                    minesModel?.nameCode ?? 'NA',
                    style: bohibaTheme.textTheme.titleSmall,
                    maxLines: 1,
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      color: Colors.black26,
                      imageUrl: "${ImagePath.companyLogo}/${minesModel?.logo}",
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: bohibaTheme.colorScheme.surface,
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (context, url) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: bohibaTheme.colorScheme.surface,
                          child: AutoSizeText(
                            minesModel?.nameCode ?? 'NA',
                            style: bohibaTheme.textTheme.bodyMedium,
                            maxLines: 1,
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                          radius: 20,
                          backgroundColor: bohibaTheme.colorScheme.surface,
                          child: Icon(
                            Icons.image,
                            color: bohibaTheme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Gap(ScreenUtils.width10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      minesModel?.name.toString() ?? '',
                      style: bohibaTheme.textTheme.headlineSmall,
                    ),
                    Text(
                      '${minesModel?.district ?? ''}, ${minesModel?.state ?? ''}',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                        color: bohibaTheme.textTheme.titleMedium!.color,
                        fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
