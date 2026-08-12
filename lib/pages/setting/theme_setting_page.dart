import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import '/component/screen_utils.dart';
import '/controllers/theme_controller.dart';
import '/dist/enums/app_enums.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';

class ThemeSettingPage extends GetView<ThemeController> {
  const ThemeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(title: 'Appearance'),
      body: Obx(() {
        final mode = controller.appThemeMode.value;
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width15,
            vertical: ScreenUtils.height20,
          ),
          children: [
            Text('Theme Mode', style: bohibaTheme.textTheme.headlineMedium),
            Gap(ScreenUtils.height10),

            // --- Mode tiles ---
            _ModeTile(
              icon: Remix.sun_line,
              label: 'Light',
              subtitle: 'Always use light theme',
              selected: mode == AppThemeMode.light,
              onTap: () => controller.changeMode(AppThemeMode.light),
            ),
            _ModeTile(
              icon: Remix.moon_line,
              label: 'Dark',
              subtitle: 'Always use dark theme',
              selected: mode == AppThemeMode.dark,
              onTap: () => controller.changeMode(AppThemeMode.dark),
            ),
            _ModeTile(
              icon: Remix.settings_line,
              label: 'System',
              subtitle: 'Follow device system theme',
              selected: mode == AppThemeMode.system,
              onTap: () => controller.changeMode(AppThemeMode.system),
            ),
            _ModeTile(
              icon: Remix.time_line,
              label: 'Time Based',
              subtitle: 'Swicontrollerh to dark mode on a schedule',
              selected: mode == AppThemeMode.timeBased,
              onTap: () => controller.changeMode(AppThemeMode.timeBased),
            ),

            // --- Schedule section (only when timeBased is active) ---
            if (mode == AppThemeMode.timeBased) ...[
              Gap(ScreenUtils.height30),
              Text('Dark Mode Schedule',
                  style: bohibaTheme.textTheme.headlineMedium),
              Gap(ScreenUtils.height5),
              Text(
                'Dark mode will activate between the times you set below.',
                style: bohibaTheme.textTheme.bodySmall,
              ),
              Gap(ScreenUtils.height10),

              LinearBoxWidget(
                header: 'Dark mode starts',
                widget: _TimeButton(
                  time: controller.darkStart.value,
                  placeholder: 'Set time',
                  onPick: (picked) => _saveStart(controller, context, picked),
                ),
              ),
              LinearBoxWidget(
                header: 'Dark mode ends',
                widget: _TimeButton(
                  time: controller.darkEnd.value,
                  placeholder: 'Set time',
                  onPick: (picked) => _saveEnd(controller, context, picked),
                ),
              ),

              if (controller.darkStart.value != null ||
                  controller.darkEnd.value != null)
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtils.height10),
                  child: TextButton.icon(
                    onPressed: controller.clearSchedule,
                    icon: Icon(Remix.delete_bin_line,
                        size: 16.sp, color: bohibaTheme.colorScheme.error),
                    label: Text(
                      'Clear schedule',
                      style: TextStyle(color: bohibaTheme.colorScheme.error),
                    ),
                  ),
                ),

              // Preview of the current effective theme.
              Padding(
                padding: EdgeInsets.only(top: ScreenUtils.height10),
                child: Obx(() {
                  final isDark = controller.themeMode.value == ThemeMode.dark;
                  return Row(
                    children: [
                      Icon(
                        isDark ? Remix.moon_fill : Remix.sun_fill,
                        size: 16.sp,
                        color: bohibaTheme.colorScheme.primary,
                      ),
                      Gap(6.w),
                      Text(
                        isDark
                            ? 'Dark mode is active now'
                            : 'Light mode is active now',
                        style: bohibaTheme.textTheme.bodySmall,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ],
        );
      }),
    );
  }

  Future<void> _saveStart(ThemeController controller, BuildContext context,
      TimeOfDay picked) async {
    final end = controller.darkEnd.value ?? picked;
    await controller.saveSchedule(start: picked, end: end);
  }

  Future<void> _saveEnd(ThemeController controller, BuildContext context,
      TimeOfDay picked) async {
    final start = controller.darkStart.value ?? picked;
    await controller.saveSchedule(start: start, end: picked);
  }
}

// ---------------------------------------------------------------------------
// Mode selection tile
// ---------------------------------------------------------------------------

class _ModeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = bohibaTheme.colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.08)
              : bohibaTheme.cardColor,
          border: Border.all(
            color: selected ? primary : bohibaTheme.dividerColor,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: selected ? primary : bohibaTheme.iconTheme.color,
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: bohibaTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                        color: selected ? primary : null,
                      )),
                  Text(subtitle, style: bohibaTheme.textTheme.bodySmall),
                ],
              ),
            ),
            if (selected)
              Icon(Remix.checkbox_circle_fill, size: 20.sp, color: primary),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tappable time display button
// ---------------------------------------------------------------------------

class _TimeButton extends StatelessWidget {
  final TimeOfDay? time;
  final String placeholder;
  final void Function(TimeOfDay) onPick;

  const _TimeButton({
    required this.time,
    required this.placeholder,
    required this.onPick,
  });

  String _format(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (picked != null) onPick(picked);
      },
      child: Text(
        time != null ? _format(time!) : placeholder,
        style: bohibaTheme.textTheme.bodyMedium?.copyWith(
          color: time != null
              ? bohibaTheme.colorScheme.primary
              : bohibaTheme.textTheme.bodySmall?.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
