import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/question_model.dart';
import '../../../../l10n/app_localizations.dart';

class QuestionCard extends StatefulWidget {
  final QuestionModel question;
  final Color categoryColor;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const QuestionCard({
    super.key,
    required this.question,
    required this.categoryColor,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0;
  final double _swipeThreshold = 100;
  late final AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _controller.addListener(() {
      final animation = _animation;
      if (animation != null) {
        setState(() {
          _dragOffset = animation.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _animateTo(double target, {VoidCallback? onCompleted}) async {
    _controller.stop();
    _animation = Tween<double>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    await _controller.forward(from: 0);
    if (onCompleted != null) {
      onCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final rotation = (_dragOffset / screenWidth) * 0.08;
    final scale = 1 - (_dragOffset.abs() / screenWidth) * 0.03;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_controller.isAnimating) {
          _controller.stop();
        }
        setState(() {
          _dragOffset += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset < -_swipeThreshold && widget.onSwipeRight != null) {
          final target = -screenWidth * 1.2;
          _animateTo(target, onCompleted: () {
            widget.onSwipeRight!();
            setState(() {
              _dragOffset = 0;
            });
          });
        } else if (_dragOffset > _swipeThreshold && widget.onSwipeLeft != null) {
          final target = screenWidth * 1.2;
          _animateTo(target, onCompleted: () {
            widget.onSwipeLeft!();
            setState(() {
              _dragOffset = 0;
            });
          });
        } else {
          _animateTo(0);
        }
      },
      child: Transform.translate(
        offset: Offset(_dragOffset * 0.5, 0),
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale.clamp(0.96, 1.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.categoryColor,
                    widget.categoryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: widget.categoryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // "Never Have I Ever..." prefix
                    Text(
                      t.game_never_have_i_ever,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40.h),

                    // Question text
                    Text(
                      widget.question.text,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40.h),

                    // Swipe hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textLight.withOpacity(0.5),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          t.game_swipe_hint,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textLight.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textLight.withOpacity(0.5),
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
