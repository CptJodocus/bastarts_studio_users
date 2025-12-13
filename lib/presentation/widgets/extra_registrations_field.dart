import 'package:bastarts_studio_users/constants/colors.dart';
import 'package:bastarts_studio_users/data/dance_class_repository.dart';
import 'package:bastarts_studio_users/data/extra_class_provider.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/widgets/class_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExtraRegistrationsField extends ConsumerStatefulWidget {
  const ExtraRegistrationsField(this.danceClass, {super.key});

  final DanceClass danceClass;
  @override
  ConsumerState<ExtraRegistrationsField> createState() => _ExtraRegistrationsFieldState();
}

class _ExtraRegistrationsFieldState extends ConsumerState<ExtraRegistrationsField> {
  List<DanceClass> selectedClasses = [];

  void toggleSelectedClass(DanceClass danceClass) {
    final selectedClassIndex = selectedClasses.indexWhere((element) => element.classId == danceClass.classId);

    if (selectedClassIndex == -1) {
      selectedClasses.add(danceClass);
    } else {
      selectedClasses.removeAt(selectedClassIndex);
    }

    ref.read(extraClassProvider.notifier).setExtraClassList(selectedClasses);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allClassesValue = ref.watch(danceClassesStreamProvider);
    final extraClasses = ref.watch(extraClassProvider);

    return allClassesValue.when(
      data: (data) {
        final otherSameDayClasses =
            data
                .where(
                  (element) =>
                      DateUtils.isSameDay(element.startTime, widget.danceClass.startTime) &&
                      element.classId != widget.danceClass.classId,
                )
                .toList();

        if (widget.danceClass.connectedClassId != null) {
          final connectedClass = data.firstWhere((element) => element.classId == widget.danceClass.connectedClassId);
          final bool connectedClassSelected =
              extraClasses.indexWhere((element) => element.classId == connectedClass.classId) != -1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Obišči oba klasa za samo ${widget.danceClass.packagePrice}€',
                style: TextTheme.of(context).bodySmall,
              ),
              GestureDetector(
                child: ClassCard(
                  danceClass: connectedClass,
                  trailing: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(connectedClassSelected ? MyColors.green : Colors.white),
                      fixedSize: WidgetStatePropertyAll(Size(160, 44)),
                    ),
                    child:
                        connectedClassSelected
                            ? Icon(Icons.check, color: Colors.white, size: 24)
                            : Text('Dodaj Prijavo'),
                  ),
                ),
                onTap: () => toggleSelectedClass(connectedClass),
              ),
            ],
          );
        } else if (otherSameDayClasses.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                <Widget>[Text('Obišči še ostale klase v dnevu', style: TextTheme.of(context).bodySmall)] +
                List.generate(otherSameDayClasses.length, (index) {
                  final danceClass = otherSameDayClasses[index];

                  final bool sameDayClassSelected =
                      extraClasses.indexWhere((element) => element.classId == danceClass.classId) != -1;
                  return GestureDetector(
                    child: ClassCard(
                      danceClass: danceClass,
                      trailing: ElevatedButton(
                        onPressed: null,
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(sameDayClassSelected ? MyColors.green : Colors.white),
                        ),
                        child: sameDayClassSelected ? Icon(Icons.check) : Text('Dodaj Prijavo'),
                      ),
                    ),
                    onTap: () => toggleSelectedClass(danceClass),
                  );
                }),
          );
        } else {
          return SizedBox.shrink();
        }
      },
      error: (err, stack) => SizedBox.shrink(),
      loading: () => SizedBox.shrink(),
    );
  }
}
