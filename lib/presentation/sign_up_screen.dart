import 'package:bastarts_studio_users/domain/dance_class.dart';
import 'package:bastarts_studio_users/presentation/sign_up_screen_controller.dart';
import 'package:bastarts_studio_users/presentation/widgets/backup_network_image.dart';
import 'package:bastarts_studio_users/presentation/widgets/responsive_two_column_layout.dart';
import 'package:bastarts_studio_users/presentation/widgets/sign_up_class_info.dart';
import 'package:bastarts_studio_users/presentation/widgets/sign_up_fields.dart';
import 'package:bastarts_studio_users/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key, required this.danceClass});

  final DanceClass danceClass;

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthDayController;
  late final TextEditingController _birthYearController;

  late final TextEditingController _parentNameController;
  late final TextEditingController _parentSurnameController;
  late final TextEditingController _parentEmailController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _birthDayController = TextEditingController();
    _birthYearController = TextEditingController();

    _parentNameController = TextEditingController();
    _parentSurnameController = TextEditingController();
    _parentEmailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _birthDayController.dispose();
    _birthYearController.dispose();

    _parentNameController.dispose();
    _parentSurnameController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  var _target = 1.0;

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(signUpScreenControllerProvider);
    ref.listen(signUpScreenControllerProvider, (previous, next) {
      next.showAlertDialogOnError(context);
    });

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
                        child: BackupNetworkImage(imageUrl: widget.danceClass.imageDownloadUrl),
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
                      endContent: SignUpFields(
                        danceClass: widget.danceClass,
                        nameController: _nameController,
                        surnameController: _surnameController,
                        emailController: _emailController,
                        birthDayController: _birthDayController,
                        birthYearController: _birthYearController,
                        parentNameController: _parentNameController,
                        parentSurnameController: _parentSurnameController,
                        parentEmailController: _parentEmailController,
                      ),
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
