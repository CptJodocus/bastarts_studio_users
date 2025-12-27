import 'package:bastarts_studio_users/data/dance_class_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherInfoScreen extends ConsumerWidget {
  const TeacherInfoScreen(this.classId, {super.key});

  final String classId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final danceClassValue = ref.watch(danceClassStreamProvider(classId));
    final studentsValue = ref.watch(studentStreamProvider(classId));

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(32),
        child: danceClassValue.when(
          data:
              (danceClass) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(danceClass!.fullTeacherNameNewLine, style: TextTheme.of(context).labelLarge),
                  SizedBox(height: 8),
                  Text(danceClass.date, style: TextTheme.of(context).bodySmall),
                  Text(danceClass.classDuration, style: TextTheme.of(context).bodySmall),
                  Text(danceClass.priceString, style: TextTheme.of(context).bodySmall),
                  SizedBox(height: 32),

                  studentsValue.when(
                    data: (data) => Text('$data prijavljenih tečajnikov'),
                    error: (err, stack) {
                      debugPrint(stack.toString());
                      return Text('Prišlo je do napake');
                    },
                    loading: () => CupertinoActivityIndicator(),
                  ),
                ],
              ),
          error:
              (err, stack) => Center(
                child: Text('Prišlo je do napake'),
              ),
          loading: () => CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
