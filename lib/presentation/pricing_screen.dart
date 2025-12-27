import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bastarts_studio_users/presentation/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

enum Dvorana { large, small }

enum ViewMode { table, example }

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  Set<Dvorana> _selectedDvorana = {Dvorana.large};
  int classPrice = 12;
  int tecajniki = 10;
  bool snemanje = true;
  Set<ViewMode> _selectedViewMode = {ViewMode.table};

  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  void updateSelectedDvorana(Set<Dvorana> newSelection) {
    setState(() {
      _selectedDvorana = newSelection;
    });
  }

  void updateSelectedViewMode(Set<ViewMode> newSelection) {
    setState(() {
      _selectedViewMode = newSelection;
    });
  }

  void updateClassPrice(int? newPrice) {
    if (newPrice != null) {
      setState(() {
        classPrice = newPrice;
      });
    }
  }

  void updateTecajniki(int? newTecajniki) {
    if (newTecajniki != null) {
      setState(() {
        tecajniki = newTecajniki;
      });
    }
  }

  int calculateStudioDvoranaPrice(int students) {
    int studio = _selectedDvorana.first == Dvorana.large ? 40 : 30;

    int result = 0;

    if (classPrice == 8 || classPrice == 9) {
      result = min(studio - (studio % 2), students * 2);
    } else if (classPrice >= 10 && classPrice <= 12) {
      result = min(studio - (studio % 3), students * 3);
    } else if (classPrice >= 13 && classPrice <= 15) {
      result = min(studio - (studio % 4), students * 4);
    } else if (classPrice >= 16) {
      result = min(studio - (studio % 5), students * 5);
    } else {
      result = 0; // Default case if price is below 8
    }

    if (students * classPrice - students - calculateStudioFootage(students) - 50 < result) {
      return max(students * classPrice - students - calculateStudioFootage(students) - 50, 0);
    } else {
      return result;
    }
  }

  double calculateOwnStudioPrice() {
    if (_selectedDvorana.first == Dvorana.large) {
      return 35 * 1.5;
    } else {
      return 25 * 1.5;
    }
  }

  int calculateStudioFootage(int students) {
    if (!snemanje) {
      return 0;
    }

    if (students < 6) {
      return 0;
    } else {
      return min(5 + (students - 6) * 2, 35);
    }
  }

  double calculateTotalCost(bool studio) {
    double result = 0;

    if (studio) {
      result = calculateStudioDvoranaPrice(tecajniki) + tecajniki.roundToDouble();
      if (snemanje) result = result + calculateStudioFootage(tecajniki);
    } else {
      result = calculateOwnStudioPrice();
      if (snemanje) result = result + 50;
    }

    print(result);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle mySegmentedButtonStyle = ButtonStyle(
      foregroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Colors.white : Colors.black,
      ),
      backgroundColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Colors.black : Colors.transparent,
      ),
      side: const WidgetStatePropertyAll(BorderSide(color: Colors.black)),
      textStyle: WidgetStatePropertyAll(TextTheme.of(context).bodyMedium!.copyWith(fontSize: 16)),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        spacing: 32,
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: Text('Studio Cenik', style: TextTheme.of(context).labelMedium)),
          ),
          Expanded(
            child: ResponsiveCenter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Text('Cena klasa:'),
                          DropdownButton(
                            value: classPrice,
                            style: TextTheme.of(context).bodyMedium,
                            items: List.generate(
                              11,
                              (index) => DropdownMenuItem(
                                value: 10 + index,
                                child: Text('${10 + index} €'),
                              ),
                            ),
                            onChanged: (value) => updateClassPrice(value),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Snemanje'),
                          Checkbox(
                            value: snemanje,
                            onChanged:
                                (value) => setState(() {
                                  snemanje = !snemanje;
                                }),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SegmentedButton(
                        segments: [
                          ButtonSegment<ViewMode>(
                            value: ViewMode.table,
                            label: Text('Prikaži tabele'),
                          ),
                          ButtonSegment<ViewMode>(
                            value: ViewMode.example,
                            label: Text('Prikaži primer'),
                          ),
                        ],
                        selected: _selectedViewMode,
                        showSelectedIcon: true,
                        onSelectionChanged: (selection) => updateSelectedViewMode(selection),
                        style: mySegmentedButtonStyle,
                      ),
                    ),
                    _selectedViewMode.first == ViewMode.example
                        ? SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 12,
                            children: [
                              Text('Število tečajnikov:'),
                              DropdownButton(
                                value: tecajniki,
                                style: TextTheme.of(context).bodyMedium,
                                items: List.generate(
                                  40,
                                  (index) => DropdownMenuItem(
                                    value: 1 + index,
                                    child: Text('${index + 1}'),
                                  ),
                                ),
                                onChanged: (value) => updateTecajniki(value),
                              ),
                            ],
                          ),
                        )
                        : SliverToBoxAdapter(),
                    SliverPadding(
                      padding: EdgeInsets.only(top: 120),
                      sliver: SliverStickyHeader(
                        sticky: _selectedViewMode.first == ViewMode.table,

                        header: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Dvorana', style: TextTheme.of(context).labelLarge),
                                  IconButton(
                                    onPressed: () {
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog.adaptive(
                                            content: Text(
                                              '25% popusta na redno ceno najema dvorane (zaokroženo).\n\n0€ dokler učitelj nima garantiranih vsaj 50€ dobička, nato približno 30% cene klasa na tečajnika, dokler se ne pokrije cena dvorane.',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.help),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.black38),
                              SegmentedButton(
                                segments: [
                                  ButtonSegment<Dvorana>(
                                    value: Dvorana.large,
                                    label: Text('Velika'),
                                  ),
                                  ButtonSegment<Dvorana>(
                                    value: Dvorana.small,
                                    label: Text('Mala'),
                                  ),
                                ],
                                selected: _selectedDvorana,
                                showSelectedIcon: true,
                                onSelectionChanged: (selection) => updateSelectedDvorana(selection),
                                style: mySegmentedButtonStyle,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Container(
                                color: Colors.black12,
                                child: Row(
                                  children: [
                                    Expanded(child: Center(child: Text('Studio'))),
                                    Expanded(child: Center(child: Text('Lastna Organizacija'))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        sliver:
                            _selectedViewMode.first == ViewMode.table
                                ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: 16,
                                    (context, index) {
                                      if (index == 15) {
                                        return Center(
                                          child: Text('...'),
                                        );
                                      }

                                      return ComparisonRow(
                                        index: index,
                                        studio: calculateStudioDvoranaPrice(index + 1),
                                        own: calculateOwnStudioPrice(),
                                      );
                                    },
                                  ),
                                )
                                : SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(child: Text('${calculateStudioDvoranaPrice(tecajniki)} €')),
                                        ),
                                        Expanded(child: Center(child: Text('${calculateOwnStudioPrice()} €'))),
                                      ],
                                    ),
                                  ),
                                ),
                      ),
                    ),
                    snemanje
                        ? SliverPadding(
                          padding: const EdgeInsets.only(top: 120.0),
                          sliver: SliverStickyHeader(
                            sticky: _selectedViewMode.first == ViewMode.table,

                            header: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Snemanje', style: TextTheme.of(context).labelLarge),
                                      IconButton(
                                        onPressed: () {
                                          showAdaptiveDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog.adaptive(
                                                content: Text(
                                                  '15€ popusta na osnovno ceno snemanja\n\n0€ za prvih 6 tečajnikov.\n5€ za 7 tečajnikov in dodatne 2€ za vsakega tečajnika nad 7, do največ 35€.',
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.help),
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.black38),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Container(
                                    color: Colors.black12,
                                    child: Row(
                                      children: [
                                        Expanded(child: Center(child: Text('Studio'))),
                                        Expanded(child: Center(child: Text('Lastna Organizacija'))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            sliver:
                                _selectedViewMode.first == ViewMode.table
                                    ? SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        childCount: 26,
                                        (context, index) {
                                          if (index == 25) {
                                            return Center(
                                              child: Text('...'),
                                            );
                                          }

                                          return ComparisonRow(
                                            index: index,
                                            studio: calculateStudioFootage(index),
                                            own: 50,
                                          );
                                        },
                                      ),
                                    )
                                    : SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Center(child: Text('${calculateStudioFootage(tecajniki)} €')),
                                            ),
                                            Expanded(child: Center(child: Text('50 €'))),
                                          ],
                                        ),
                                      ),
                                    ),
                          ),
                        )
                        : SliverToBoxAdapter(),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 120.0),
                      sliver: SliverStickyHeader(
                        sticky: false,
                        header: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Administracija', style: TextTheme.of(context).labelLarge),
                                  IconButton(
                                    onPressed: () {
                                      showAdaptiveDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog.adaptive(
                                            content: Text(
                                              'Vodenje prijav, izdelava letaka, obveščanje na spletnih in družabnih medijih, sprejem tečajnikov in pobiranje vadnine.\n\nNi vklučeno v lastni organizaciji.',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.help),
                                  ),
                                ],
                              ),
                              Divider(color: Colors.black38),
                              SizedBox(
                                height: 32,
                              ),
                              Container(
                                color: Colors.black12,
                                child: Row(
                                  children: [
                                    Expanded(child: Center(child: Text('Studio'))),
                                    Expanded(child: Center(child: Text('Lastna Organizacija'))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32.0),
                            child: Row(
                              children: [
                                Expanded(child: Center(child: Text('1€/tečajnika'))),
                                Expanded(child: Center(child: Text('/'))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 120),
                      sliver: SliverStickyHeader(
                        header: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Skupaj', style: TextTheme.of(context).labelLarge),

                              Divider(color: Colors.black38),
                              SizedBox(
                                height: 32,
                              ),
                              _selectedViewMode.first == ViewMode.table
                                  ? Center(
                                    child: Text('Izberi prikaz primera za izračun'),
                                  )
                                  : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 16,
                                    children: [
                                      Text('Celoten priliv: $tecajniki x $classPrice € = ${tecajniki * classPrice} €'),

                                      Container(
                                        color: Colors.black12,
                                        child: Row(
                                          children: [
                                            Expanded(child: Center(child: Text('Studio'))),
                                            Expanded(child: Center(child: Text('Lastna Organizacija'))),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        spacing: 8,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  'Dvorana: ${calculateStudioDvoranaPrice(tecajniki)}€',
                                                  maxLines: 1,
                                                ),
                                                snemanje
                                                    ? AutoSizeText(
                                                      'Snemanje: ${calculateStudioFootage(tecajniki)}€',
                                                      maxLines: 1,
                                                    )
                                                    : SizedBox.shrink(),
                                                AutoSizeText('Administracija: $tecajniki€', maxLines: 1),
                                                SizedBox(
                                                  height: 32,
                                                ),
                                                AutoSizeText(
                                                  'Končni dobiček: ${tecajniki * classPrice - calculateTotalCost(true)}€',
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText('Dvorana: ${calculateOwnStudioPrice()}€', maxLines: 1),
                                                snemanje
                                                    ? AutoSizeText('Snemanje: 50€', maxLines: 1)
                                                    : SizedBox.shrink(),
                                                AutoSizeText('Administracija: /', maxLines: 1),
                                                SizedBox(
                                                  height: 32,
                                                ),
                                                AutoSizeText(
                                                  'Končni dobiček: ${tecajniki * classPrice - calculateTotalCost(false)}€',
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComparisonRow extends StatelessWidget {
  const ComparisonRow({
    super.key,
    required this.index,
    required this.studio,
    required this.own,
  });

  final int index;
  final num studio;
  final num own;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.black38),
              ),
            ),
            Expanded(child: Center(child: Text('$studio €'))),
            SizedBox(width: 72),
            Expanded(child: Center(child: Text('$own €'))),
            SizedBox(width: 36),
          ],
        ),
        Divider(
          color: Colors.black12,
        ),
      ],
    );
  }
}
