import 'package:bastarts_studio_users/data/dance_class_repository.dart';
import 'package:bastarts_studio_users/presentation/widgets/card_opener.dart';
import 'package:bastarts_studio_users/presentation/widgets/class_card.dart';
import 'package:bastarts_studio_users/presentation/widgets/class_list_separator.dart';
import 'package:bastarts_studio_users/utils/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    initializeDateFormatting('sl');
    super.initState();
  }

  final bool maintenance = false;

  @override
  Widget build(BuildContext context) {
    final danceClassListValue = ref.watch(danceClassesStreamProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          maintenance
              ? Center(child: Text('Trenutno ni napovedanih nobenih klasov'))
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: danceClassListValue.when(
                  data:
                      (data) =>
                          data.isNotEmpty
                              ? GroupedListView(
                                elements: data,
                                groupBy:
                                    (element) => DateTime(
                                      element.startTime.year,
                                      element.startTime.month,
                                      element.startTime.day,
                                    ),
                                itemComparator:
                                    (element1, element2) => element1.startTime
                                        .compareTo(element2.startTime),
                                itemBuilder: (context, element) {
                                  return CardOpener(danceClass: element);
                                },
                                groupSeparatorBuilder:
                                    (value) => ClassListSeparator(
                                      date: kDateNameFormat.format(value),
                                    ),
                              )
                              : Center(
                                child: Text(
                                  'Trenutno ni napovedanih nobenih klasov',
                                ),
                              ),
                  error:
                      (err, stack) => Center(
                        child: Text('Prišlo je do napake\n${err.toString()}'),
                      ),
                  loading: () {
                    final List<Widget> loadingUI = List.generate(
                      3,
                      (index) => ClassCard.loading(),
                    )..insert(0, ClassListSeparator());

                    return SingleChildScrollView(
                      child: Column(children: loadingUI),
                    );
                  },
                ),
              ),
    );
  }
}
