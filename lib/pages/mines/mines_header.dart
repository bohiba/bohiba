import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/model/mines_model.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MinesHeader extends StatelessWidget {
  final MinesModel minesModel;
  const MinesHeader({super.key, required this.minesModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtils.height15),
          child: Row(
            children: [
              CircleAvatar(
                radius: ScreenUtils.width25,
                backgroundColor: bohibaTheme.dividerColor,
                backgroundImage: NetworkImage(
                  GlobalService.getAvatarUrl(minesModel.name ?? 'UN'),
                ),
              ),
              Gap(ScreenUtils.width10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      minesModel.name.toString(),
                      style: bohibaTheme.textTheme.headlineSmall,
                    ),
                    Text(
                      '${minesModel.district ?? ''}, ${minesModel.state ?? ''}',
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
