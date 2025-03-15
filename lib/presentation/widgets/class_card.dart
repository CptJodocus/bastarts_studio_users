import 'package:auto_size_text/auto_size_text.dart';
import 'package:bastarts_studio_users/constants/colors.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/widgets/responsive_center.dart';
import 'package:bastarts_studio_users/presentation/widgets/responsive_two_column_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({super.key, required this.danceClass}) : loading = false;

  const ClassCard.loading({super.key}) : loading = true, danceClass = null;

  final DanceClass? danceClass;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    //TODO get from network
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ResponsiveCenter(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: loading ? ClassCardLoading() : ClassCardContents(danceClass: danceClass!),
        ),
      ),
    );
  }
}

class ClassCardContents extends StatefulWidget {
  const ClassCardContents({super.key, required this.danceClass});

  final DanceClass danceClass;

  @override
  State<ClassCardContents> createState() => _ClassCardContentsState();
}

class _ClassCardContentsState extends State<ClassCardContents> {
  late final AutoSizeGroup autoSizeGroup;

  @override
  void initState() {
    autoSizeGroup = AutoSizeGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              // colors: [Colors.black.withAlpha((255 * 1).floor()), Colors.black.withAlpha(0)],
              colors: [Colors.black.withAlpha(0), Colors.black12, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.65, 1],
            ),
          ),

          child: Image(
            image: NetworkImage(widget.danceClass.imageDownloadUrl ?? 'https://i.ibb.co/MkyDCxrb/backup-banner.png'),
            height: 300,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          bottom: 8,
          left: 16,
          right: 16,
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ResponsiveTwoColumnLayout(
                  startContent: AutoSizeText(
                    widget.danceClass.fullTeacherNameInline,
                    style: TextTheme.of(context).labelMedium!.copyWith(height: 0.8),
                    group: autoSizeGroup,
                    maxLines: 1,
                  ),
                  endContent: AutoSizeText(
                    widget.danceClass.classDuration,
                    style: TextTheme.of(context).labelMedium!.copyWith(height: 0.8),
                    group: autoSizeGroup,
                    maxLines: 1,
                  ),
                  columnContent: AutoSizeText(
                    widget.danceClass.columnDetails,
                    style: TextTheme.of(context).labelMedium,
                  ),
                  spacing: 32,
                ),
              ),
              ElevatedButton(onPressed: null, child: Text('Prijava')),
            ],
          ),
        ),
      ],
    );
  }
}

class ClassCardLoading extends StatelessWidget {
  const ClassCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: MyColors.shimmerBackground),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(color: MyColors.grayDark, delay: 1000.ms, duration: 1000.ms);
  }
}
