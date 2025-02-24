import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/widgets/responsive_two_column_layout.dart';
import 'package:bastarts_studio_users/presentation/widgets/sign_up_class_info.dart';
import 'package:bastarts_studio_users/presentation/widgets/sign_up_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.danceClass});

  final DanceClass danceClass;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _target = 1.0;

  @override
  Widget build(BuildContext context) {
    return Animate(target: _target).custom(
      duration: 300.ms,
      builder: (context, value, child) {
        final backgroundColor = Color.lerp(Colors.black, Colors.white, value);
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              setState(() {
                _target = 0;
              });
            }
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [backgroundColor!.withAlpha(0), backgroundColor.withAlpha(85), backgroundColor],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.50, 1],
                          ),
                        ),
                        child: Image(image: AssetImage(widget.danceClass.imageUri), height: 300, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ResponsiveTwoColumnLayout(
                      spacing: 64,
                      rowAlignment: MainAxisAlignment.center,
                      startContent: SignUpClassInfo(danceClass: widget.danceClass),
                      endContent: SignUpFields(),
                      wrapRowEndWithResponsiveCenter: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
