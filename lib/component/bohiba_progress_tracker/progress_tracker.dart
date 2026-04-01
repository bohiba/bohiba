import 'package:bohiba/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressTracker extends StatefulWidget {
  final int currentIndex;
  final List<Status> statusList;
  final Color? activeColor;
  final Color? inActiveColor;

  final double height;
  final bool trackerAtStart;

  const ProgressTracker({
    super.key,
    required this.currentIndex,
    required this.statusList,
    this.trackerAtStart = true,
    this.height = 75,
    this.inActiveColor = BohibaColors.borderColor,
    this.activeColor = BohibaColors.primaryColor,
  });

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  late List<Status> statuses;

  @override
  void initState() {
    super.initState();
    _updateStatusList(); // Set initial active states
  }

  /// Updates the active states of each step based on the current index.
  void _updateStatusList() {
    statuses = List.from(widget.statusList);
    for (int i = 0; i < statuses.length; i++) {
      statuses[i].active = i == 0 || i <= widget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints box) {
      // Calculate the number of inactive steps based on the available width.
      final count = (box.constrainWidth() / (1.4 * 8.0)).floor();

      return SizedBox(
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Display horizontal lines between steps.
            Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: List.generate(count, (_) {
                return SizedBox(
                  width: 8.w,
                  height: 2.2.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.inActiveColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ),
            Visibility(
              visible: !widget.trackerAtStart,
              child: Positioned(
                bottom: 0,
                child: SizedBox(
                  width: ScreenUtils.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(statuses.length, (index) {
                      return buildLineAtStart(statuses[index], index);
                    }),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.trackerAtStart,
              child: Positioned(
                bottom: 0,
                child: SizedBox(
                  width: ScreenUtils.width - ScreenUtils.width30,
                  child: buildTrackerAtStart(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Stack buildTrackerAtStart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: List.generate(statuses.length - 1, (index) {
            return Expanded(
              child: Container(
                height: 2.2.h,
                color: statuses[index + 1].active! ? widget.activeColor : BohibaColors.transparent,
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(statuses.length, (index) {
            return SizedBox(
              height: widget.height,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statuses[index].active! ? widget.activeColor : widget.inActiveColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: index == 0 ? 0 : null,
                    right: index == statuses.length - 1 ? 0 : null,
                    child: Text(
                      statuses[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: statuses[index].active! ? widget.activeColor : widget.inActiveColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  /// Builds a single step in the progress tracker when `trackerAtStart` is disabled.
  ///
  ////// This function ensures the correct sequence of `Line > Tracker > Line > Tracker Line`
  Expanded buildLineAtStart(Status status, int index) {
    final statusCount = statuses.length;

    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Stack(
          // alignment: Alignment.center,
          children: [
            // Display visual indicators for the step's status.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: status.active! && index < statusCount,
                  child: Expanded(
                    child: Container(
                      height: 2.2.h,
                      decoration: BoxDecoration(
                        color: status.active! ? widget.activeColor : widget.inActiveColor,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: status.active! && index < statusCount,
                  child: Expanded(
                    child: Container(
                      height: 2.2.h,
                      decoration: BoxDecoration(
                        color: widget.currentIndex != index || widget.currentIndex + 1 == statusCount ? widget.activeColor : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Display the label or name of the step.
            Positioned(
              bottom: 0,
              child: Text(
                status.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: status.active! ? widget.activeColor : widget.inActiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Status {
  final String name;
  bool? active;

  Status({
    required this.name,
    this.active = false,
  });
}
