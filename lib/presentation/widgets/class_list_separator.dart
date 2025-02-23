import 'package:bastarts_studio_users/constants/colors.dart';
import 'package:bastarts_studio_users/presentation/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClassListSeparator extends StatelessWidget {
  const ClassListSeparator({super.key, this.date});

  final String? date;

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            date != null
                ? Text(date!, style: TextTheme.of(context).headlineMedium)
                : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                        width: 90,
                        height: 31,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: MyColors.shimmerBackground,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(color: MyColors.shimmerForeground, delay: 1000.ms, duration: 1000.ms),
                ),
            Divider(color: date != null ? Colors.white : MyColors.shimmerForeground, height: 0),
          ],
        ),
      ),
    );
  }
}
