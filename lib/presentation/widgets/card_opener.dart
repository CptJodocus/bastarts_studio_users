import 'package:animations/animations.dart';
import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/sign_up_screen.dart';
import 'package:bastarts_studio_users/presentation/widgets/class_card.dart';
import 'package:flutter/material.dart';

class CardOpener extends StatelessWidget {
  const CardOpener({super.key, required this.danceClass});

  final DanceClass danceClass;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedBuilder: (BuildContext context, void Function() action) {
        return ClassCard(danceClass: danceClass);
      },
      openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
        return SignUpScreen(danceClass: danceClass);
      },
      closedColor: Colors.transparent,
    );
  }
}
