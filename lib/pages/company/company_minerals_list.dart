import 'package:bohiba/component/ui/random_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '/model/company_model.dart';
import '/theme/bohiba_theme.dart';

class CompanyMineralsList extends StatelessWidget {
  final List<MineralModel> minerals;

  const CompanyMineralsList({super.key, required this.minerals});

  @override
  Widget build(BuildContext context) {
    if (minerals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Minerals', style: bohibaTheme.textTheme.bodyLarge),
          Gap(8.h),
          SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: minerals.length,
              separatorBuilder: (_, __) => Gap(8.w),
              itemBuilder: (_, i) => _MineralChip(mineral: minerals[i]),
            ),
          ),
          Gap(16.h),
        ],
      ),
    );
  }
}

class _MineralChip extends StatelessWidget {
  final MineralModel mineral;

  const _MineralChip({required this.mineral});

  @override
  Widget build(BuildContext context) {
    Color color = RandomColorPicker.getRandomColor();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      child: Text(
        mineral.name ?? '',
        textAlign: TextAlign.center,
        style: bohibaTheme.textTheme.bodySmall!
            .copyWith(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
