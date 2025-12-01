import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final int skeletonLength;
  final BorderRadius? borderRadius;

  const AppSkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.skeletonLength = 1,
    this.borderRadius,
  });

  @override
  State<AppSkeletonLoader> createState() => _AppSkeletonLoaderState();
}

class _AppSkeletonLoaderState extends State<AppSkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = bohibaTheme.cardColor;
    final highlightColor = bohibaTheme.dividerColor;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        children: List.generate(widget.skeletonLength, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: ClipRRect(
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        final shimmerWidth = bounds.width * 0.95;
                        final dx = bounds.width * _animation.value;

                        return LinearGradient(
                          begin: const Alignment(-2.2, -1.2),
                          end: const Alignment(1.2, 1.2),
                          colors: [
                            Colors.grey,
                            highlightColor,
                            Colors.grey,
                          ],
                          stops: [
                            ((dx - shimmerWidth) / bounds.width).clamp(0.0, 1.0),
                            (dx / bounds.width).clamp(0.0, 1.0),
                            ((dx + shimmerWidth) / bounds.width).clamp(0.0, 1.0),
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.lighten,
                      child: Container(
                        width: widget.width ?? ScreenUtils.width,
                        height: widget.height ?? ScreenUtils.height * 0.075,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.w),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey.shade800,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 115.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  height: 5.h,
                                  width: 65.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
