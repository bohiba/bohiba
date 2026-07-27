import 'package:bohiba/component/bohiba_network_image.dart';
import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/model/company_model.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
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
              BohibaNetworkImage.circle(
                imageUrl: '${ImagePath.companyLogo}/${minesModel?.logo}',
                size: 40,
                fallbackText: minesModel?.nameCode ?? minesModel?.name,
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
