import 'dart:math';

import 'package:expenso/Models/Currncy.dart';
import 'package:expenso/Models/Expense.dart';
import 'package:expenso/Models/Expense_Category.dart';
import 'package:expenso/firebase/firestore_helper.dart';
import 'package:expenso/providers/UserProvider.dart';
import 'package:expenso/widget/bar_graph_daily_expenses.dart';
import 'package:expenso/widget/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:expenso/theme/colors.dart';

import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeDay = 3;

  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  List<List<num>> groupExpensesByDay(List<Expense> expenses) {
    List<List<num>> daysGrouped = [
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0],
      [4, 0],
      [5, 0],
      [6, 0]
    ];
    // String day = DateFormat('EEEE').format(ex.date.toDate());
    for (Expense ex in expenses) {
      daysGrouped[ex.date.toDate().weekday - 1][1] += ex.price;
    }
    return daysGrouped;
  }

  Map<ExpenseCategory, num> groupExpensesByCategory(List<Expense> expenses) {
    List<ExpenseCategory> categories = ExpenseCategory.values;
    Map<ExpenseCategory, num> daysGrouped = {};
    for (ExpenseCategory cat in categories) {
      daysGrouped[cat] = 0;
    }

    for (Expense ex in expenses) {
      daysGrouped[ex.cat] = daysGrouped[ex.cat]! + ex.price;
    }
    return daysGrouped;
  }

  DateTime dateSelected = DateTime.now();
  DatePickerController datePickerController = DatePickerController();
  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: const Padding(
              padding:
                  EdgeInsets.only(top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stats",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: grey.withOpacity(0.01),
                      spreadRadius: 10,
                      blurRadius: 3,
                      // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: FutureBuilder<List<Expense>>(
                        future: FirestoreHelper.getAllDailyExpenses(
                            Provider.of<UserProvider>(context, listen: true)
                                .user!
                                .email),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              snapshot.hasError ||
                              snapshot.data == null) {
                            
                            return const CircularProgressIndicator();
                          }
                          final dailyExpenses = snapshot.data!;
                          if(dailyExpenses.isEmpty){
                            return Text("Empty Data. Please add.",style: TextStyle(fontSize: 18),);
                          }
                          double totalPrice = 0;
                          for (Expense ex in dailyExpenses) {
                            totalPrice += ex.price;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total payment: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xff67727d)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${CurrencyHelper.getSymbol()}$totalPrice",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 200,
                                child: BarGraphDailyExpenses(
                                  daysGrouped:
                                      groupExpensesByDay(dailyExpenses),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              PieChartGroupedCat(
                                expensesGroupedCat:
                                    groupExpensesByCategory(dailyExpenses),
                              ),
                              SizedBox(
                                height: 100,
                              )
                            ],
                          );
                        },
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

class PieChartGroupedCat extends StatefulWidget {
  const PieChartGroupedCat({super.key, required this.expensesGroupedCat});
  final Map<ExpenseCategory, num> expensesGroupedCat;

  @override
  State<StatefulWidget> createState() => PieChartGroupedCatState();
}

class PieChartGroupedCatState extends State<PieChartGroupedCat> {
  ExpenseCategory? touchedIndex = ExpenseCategory.auto;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: widget.expensesGroupedCat.keys
              .map<Widget>(
                (e) => Indicator(
                  color: e.color,
                  text: e.name,
                  isSquare: true,
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 1,
              centerSpaceRadius: 30,
              sections: showingSections(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    num sumPrice = 0;
    for (num dayExp in widget.expensesGroupedCat.values) {
      sumPrice += dayExp;
    }

    return widget.expensesGroupedCat.entries.map<PieChartSectionData>((e) {
      const fontSize = 12.0;
      const radius = 100.0;
      const widgetSize = 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: e.key.color,
        value: e.value.toDouble(),
        title:
            '${(e.value.toDouble() / sumPrice).toStringAsPrecision(1)}%\n${e.value.toDouble()}${CurrencyHelper.getSymbol()}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _Badge(
          e.key.path,
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.imgPath, {
    required this.size,
    required this.borderColor,
  });
  final String imgPath;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          imgPath,
        ),
      ),
    );
  }
}
