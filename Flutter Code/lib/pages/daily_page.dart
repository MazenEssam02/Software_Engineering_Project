import 'package:expenso/Models/Currncy.dart';
import 'package:expenso/Models/Expense.dart';
import 'package:expenso/firebase/firestore_helper.dart';
import 'package:expenso/providers/UserProvider.dart';
import 'package:flutter/material.dart';

import 'package:expenso/theme/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:provider/provider.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
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
                        "Daily Transaction",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
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
          ),
          SizedBox(
            height: 30,
          ),
          FutureBuilder<List<Expense>>(
              future: context.watch<UserProvider>().user == null
                  ? null
                  : FirestoreHelper.getDailyExpensesByDate(
                      context.watch<UserProvider>().user!.email, dateSelected),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    snapshot.data == null) {
                  print(snapshot.error);
                  return CircularProgressIndicator();
                }
                final dailyExpenses = snapshot.data!;
                double totalPrice = 0;
                for (Expense ex in dailyExpenses) {
                  totalPrice += ex.price;
                }
                
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                          children:
                              List.generate(dailyExpenses.length, (index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (size.width - 40) * 0.7,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: grey.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            dailyExpenses[index].cat.path,
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                        width: (size.width - 90) * 0.5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dailyExpenses[index].name,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: black,
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              dailyExpenses[index]
                                                  .getFormattedTime(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: black.withOpacity(0.5),
                                                  fontWeight: FontWeight.w400),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: (size.width - 40) * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        dailyExpenses[index].price.toString() +
                                            "${CurrencyHelper.getSymbol()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 65, top: 8),
                              child: Divider(
                                thickness: 0.8,
                              ),
                            )
                          ],
                        );
                      })),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: black.withOpacity(0.4),
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              totalPrice.toString() + "${CurrencyHelper.getSymbol()}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}
