import 'dart:math';

import 'package:expenso/Models/Budget.dart';
import 'package:expenso/Models/Currncy.dart';
import 'package:expenso/firebase/firestore_helper.dart';
import 'package:expenso/providers/UserProvider.dart';
import 'package:flutter/material.dart';

import 'package:expenso/theme/colors.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  DateTime dateSelected = DateTime.now();
  DatePickerController datePickerController = DatePickerController();
  Widget getBody() {
    var size = MediaQuery.of(context).size;

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
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Budget",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      Row(
                        children: [
                          // Icon(
                          //   Icons.add,
                          //   size: 25,
                          // ),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          // Icon(Icons.search)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // TODO: Date Picker
                  HorizontalDatePickerWidget(
                    startDate: DateTime(2024, 5, 1),
                    endDate: DateTime.now(),
                    onValueSelected: (date) {
                      setState(() {
                        dateSelected = date;
                      });
                    },
                    selectedDate: dateSelected,
                    widgetWidth: MediaQuery.of(context).size.width,
                    datePickerController: datePickerController,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder<List<Budget>>(
              future: FirestoreHelper.getBudgetByDateWithPriceRatio(
                  context.watch<UserProvider>().user!.email, dateSelected),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    snapshot.data == null) {
                  return CircularProgressIndicator();
                }
                final budgetList = snapshot.data!;
                if (budgetList.isEmpty) {
                  return Text(
                    "Empty Data. Please add.",
                    style: TextStyle(fontSize: 18),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                          children: List.generate(budgetList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
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
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, bottom: 25, top: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    budgetList[index].cat.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color:
                                            Color(0xff67727d).withOpacity(0.6)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${CurrencyHelper.getSymbol()}${budgetList[index].taken}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              (budgetList[index].getRatio() *
                                                          100)
                                                      .toString() +
                                                  "%",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  color: Color(0xff67727d)
                                                      .withOpacity(0.6)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          "${CurrencyHelper.getSymbol()}${budgetList[index].originalPrice}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                              color: Color(0xff67727d)
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width: (size.width - 40),
                                        height: 4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xff67727d)
                                                .withOpacity(0.1)),
                                      ),
                                      Container(
                                        width: (size.width - 40) *
                                            min(budgetList[index].getRatio(),
                                                1),
                                        height: 4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: budgetList[index].cat.color),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
