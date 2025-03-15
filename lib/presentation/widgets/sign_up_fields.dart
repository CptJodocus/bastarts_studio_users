import 'package:bastarts_studio_users/presentation/widgets/my_form_field.dart';
import 'package:bastarts_studio_users/presentation/widgets/terms_and_conditions_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class SignUpFields extends StatefulWidget {
  const SignUpFields({super.key});

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  //TODO yeah, I think these need to go into sign up screen otherwise they get cleared when you jump from row to column. Is that a problem?
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

  void checkIfUserIsOfAge() {
    final day = int.tryParse(_birthDayController.value.text);
    final month = birthMonth;
    final year = int.tryParse(_birthYearController.value.text);
    if (day is int && month > 0 && year is int) {
      setState(() {
        ofAge = DateTime(year + 18, month, day).isBefore(DateTime.now());
      });
      if (termsAgree == true) {
        //If user already agreed to terms, and is little bebe, set to false instead
        termsAgree = ofAge;
      }
    }
  }

  void termsCheckboxOnTap(bool? value) {
    setState(() {
      termsAgree = value;
    });
  }

  final List<String> monthNames = List.generate(12, (index) => DateFormat.MMMM('sl').format(DateTime(2000, index + 1)));

  final double spacing = 12;

  int birthMonth = 0;
  bool ofAge = true;

  bool? mailingListSubscribe = false;
  bool? termsAgree = false;
  @override
  Widget build(BuildContext context) {
    //TODO this needs a bunch of validation to make sure you get actual values, and error messages where needed
    return AutofillGroup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing,
        children: [
          Row(
            spacing: spacing,
            children: [
              Expanded(
                child: MyFormField(
                  controller: _nameController,
                  labelText: 'Ime',
                  keyboardType: TextInputType.name,
                  autoFillHints: [AutofillHints.givenName],
                  textInputAction: TextInputAction.next,
                ),
              ),
              Expanded(
                child: MyFormField(
                  controller: _surnameController,
                  labelText: 'Priimek',
                  keyboardType: TextInputType.name,
                  autoFillHints: [AutofillHints.familyName],
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
          MyFormField(
            controller: _emailController,
            labelText: 'E-pošta',
            textInputAction: TextInputAction.next,
            autoFillHints: [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 8),
          Text('Datum rojstva', style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18)),
          Row(
            spacing: spacing,
            children: [
              Flexible(
                child: MyFormField(
                  controller: _birthDayController,
                  labelText: 'Dan',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  autoFillHints: [AutofillHints.birthdayDay],
                  maxLength: 2,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (_) => checkIfUserIsOfAge(),
                ),
              ),
              Expanded(
                //TODO I wish I could've figured this out for better UX, but fuck it, this is how Google does it too
                // child: DropdownMenu(
                //   dropdownMenuEntries: List.generate(12, (index) {
                //     return DropdownMenuEntry(
                //       value: index + 1,
                //       label: monthNames[index],
                //       labelWidget: Text(
                //         monthNames[index],
                //         style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 16),
                //       ),
                //     );
                //   }),
                //   label: Text('Mesec', maxLines: 1),
                //   enableSearch: true,
                //   width: 1000,
                //   enableFilter: true,
                //   menuStyle: MenuStyle(
                //     backgroundColor: WidgetStatePropertyAll(Colors.white),
                //     maximumSize: WidgetStatePropertyAll(Size(200, 800)),
                //     minimumSize: WidgetStatePropertyAll(Size(0, 300)),
                //   ),
                //   inputDecorationTheme: InputDecorationTheme(
                //     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                //     filled: true,
                //     fillColor: Colors.white,
                //     floatingLabelStyle: TextStyle(color: Colors.black),
                //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                //     border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                //   ),
                // ),
                child: DropdownButtonFormField(
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(value: index + 1, child: Text(monthNames[index]));
                  }),
                  isExpanded: true,

                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
                    filled: true,
                    fillColor: Colors.white,
                    floatingLabelStyle: TextStyle(color: Colors.black54),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: 'Mesec',
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  ),
                  onChanged: (value) {
                    if (value != null) birthMonth = value;
                    checkIfUserIsOfAge();
                  },
                ),
              ),
              Expanded(
                child: Focus(
                  onFocusChange: (value) {
                    checkIfUserIsOfAge();
                  },
                  child: MyFormField(
                    controller: _birthYearController,
                    labelText: 'Leto',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    autoFillHints: [AutofillHints.birthdayYear],
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onEditingComplete: () {
                      checkIfUserIsOfAge();
                    },
                  ),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: mailingListSubscribe,
            onChanged: (value) {
              setState(() {
                mailingListSubscribe = value;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Želim si prejemati tedenska obvestila o novih klasih',
              style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18),
            ),
          ),
          ofAge
              ? TermsAndConditionsCheckbox(value: termsAgree, onChanged: (value) => termsCheckboxOnTap(value))
              : Card(
                margin: EdgeInsets.zero,
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: spacing,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'izjava zakonitega zastopnika',
                            style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18),
                          ),
                          Text(
                            '(Izpolni starš ali zakoniti zastopnik)',
                            style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 10, color: Colors.black54),
                          ),
                        ],
                      ),
                      Row(
                        spacing: spacing,
                        children: [
                          Expanded(
                            child: MyFormField(
                              controller: _parentNameController,
                              labelText: 'Ime',
                              keyboardType: TextInputType.name,
                              autoFillHints: [AutofillHints.givenName],
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Expanded(
                            child: MyFormField(
                              controller: _parentSurnameController,
                              labelText: 'Priimek',
                              keyboardType: TextInputType.name,
                              autoFillHints: [AutofillHints.familyName],
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      MyFormField(
                        controller: _parentEmailController,
                        labelText: 'E-pošta',
                        textInputAction: TextInputAction.next,
                        autoFillHints: [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TermsAndConditionsCheckbox(value: termsAgree, onChanged: (value) => termsCheckboxOnTap(value)),
                    ],
                  ),
                ),
              ).animate(target: ofAge == true ? 0 : 1).scaleY(alignment: Alignment.topCenter).fadeIn(),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: Text('Prijavi se'),
          ),
        ],
      ),
    );
  }
}
