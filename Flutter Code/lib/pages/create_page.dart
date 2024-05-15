import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:expenso/Models/Budget.dart';
import 'package:expenso/Models/Expense.dart';
import 'package:expenso/Models/Expense_Category.dart';
import 'package:expenso/firebase/firestore_helper.dart';
import 'package:expenso/providers/UserProvider.dart';
import 'package:expenso/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:expenso/theme/colors.dart';
import 'package:provider/provider.dart';

class CreateExpenseBudgetPage extends StatefulWidget {
  const CreateExpenseBudgetPage({super.key});

  @override
  _CreateExpenseBudgetPageState createState() =>
      _CreateExpenseBudgetPageState();
}

class _CreateExpenseBudgetPageState extends State<CreateExpenseBudgetPage> {
  int activeCategory = 0;
  final TextEditingController _budgetName = TextEditingController();
  final TextEditingController _budgetPrice = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  List<ExpenseCategory> categories = ExpenseCategory.values;
  bool isLoading = false;
  DateTime? daySelected;
  Time timeSelected = Time.fromTimeOfDay(TimeOfDay.now(), 0);

  void insertBudget() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      if (_budgetPrice.text.isEmpty ||
          daySelected == null ||
          _budgetPrice.text.contains((RegExp(r'[^0-9.]')))) {
            
        CustomSnackBar(
                ctx: context,
                actionTile: "close",
                haserror: true,
                isfloating: false,
                onPressed: () {},
                title: "Please Check fields and try again")
            .show();
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FirestoreHelper.insertBudget(
        Provider.of<UserProvider>(context, listen: false).user!.email,
        Budget(
          originalPrice: double.parse(_budgetPrice.text),
          cat: categories[activeCategory],
          date: Timestamp.fromDate(
            DateTime(daySelected!.year, daySelected!.month, daySelected!.day),
          ),
        ),
      );
      CustomSnackBar(
              ctx: context,
              actionTile: "close",
              haserror: false,
              isfloating: false,
              onPressed: () {},
              title: "${_budgetName.text} has been inserted.")
          .show();
      _budgetName.clear();
      _budgetPrice.clear();
    } catch (e) {
      CustomSnackBar(
              ctx: context,
              actionTile: "close",
              haserror: true,
              isfloating: false,
              onPressed: () {},
              title: "Please try again later.")
          .show();
    }
    setState(() {
      isLoading = false;
    });
  }

  void insertDailyExpense() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      if (_budgetName.text.isEmpty ||
          _budgetPrice.text.isEmpty ||
          daySelected == null ||
          _budgetPrice.text.contains((RegExp(r'[^0-9.]')))) {
        CustomSnackBar(
                ctx: context,
                actionTile: "close",
                haserror: true,
                isfloating: false,
                onPressed: () {},
                title: "Please Check fields and try again")
            .show();
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FirestoreHelper.insertExpense(
        Provider.of<UserProvider>(context, listen: false).user!.email,
        Expense(
          name: _budgetName.text,
          price: double.parse(_budgetPrice.text),
          cat: categories[activeCategory],
          date: Timestamp.fromDate(
            DateTime(
              daySelected!.year,
              daySelected!.month,
              daySelected!.day,
              timeSelected.hour,
              timeSelected.minute,
            ),
          ),
        ),
      );
      CustomSnackBar(
              ctx: context,
              actionTile: "close",
              haserror: false,
              isfloating: false,
              onPressed: () {},
              title: "${_budgetName.text} has been inserted.")
          .show();
      _budgetName.clear();
      _budgetPrice.clear();
    } catch (e) {
      CustomSnackBar(
              ctx: context,
              actionTile: "close",
              haserror: true,
              isfloating: false,
              onPressed: () {},
              title: "Please try again later.")
          .show();
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isExpense = true;
  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Create budget",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text(
                    "Expense",
                  ),
                  selected: isExpense,
                  selectedColor: Colors.greenAccent,
                  onSelected: (value) {
                    setState(() {
                      isExpense = true;
                    });
                  },
                  elevation: 1,
                  labelPadding: const EdgeInsets.all(2.0),
                ),
                const SizedBox(
                  width: 20,
                ),
                ChoiceChip(
                  label: const Text(
                    "Budget",
                  ),
                  selected: !isExpense,
                  selectedColor: Colors.greenAccent,
                  onSelected: (value) {
                    setState(() {
                      isExpense = false;
                    });
                  },
                  elevation: 1,
                  labelPadding: const EdgeInsets.all(2.0),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              "Choose category",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: black.withOpacity(0.5)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategory = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    width: 150,
                    height: 170,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(
                            width: 2,
                            color: activeCategory == index
                                ? primary
                                : Colors.transparent),
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
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: grey.withOpacity(0.15)),
                              child: Center(
                                child: Image.asset(
                                  categories[index].path,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          Text(
                            categories[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isExpense)
                  const Text(
                    "Expense Name",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xff67727d)),
                  ),
                if (isExpense)
                  TextField(
                    controller: _budgetName,
                    cursorColor: black,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: black),
                    decoration: const InputDecoration(
                        hintText: "Enter Expense Name",
                        border: InputBorder.none),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (size.width - 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExpense ? "Expense price" : "Budget amount",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          TextField(
                            controller: _budgetPrice,
                            cursorColor: black,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black),
                            decoration: InputDecoration(
                                hintText:
                                    isExpense ? "Enter Price" : "Enter Amount",
                                border: InputBorder.none),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: isExpense ? insertDailyExpense : insertBudget,
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(15)),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              )
                            : const Icon(
                                Icons.arrow_forward,
                                color: white,
                              ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Date",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                DateTimePicker(
                  maxLines: 1,
                  type: DateTimePickerType.date,
                  dateMask: 'd MMM, yyyy',
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      hintText: "Select Day",
                      suffixIcon: Icon(
                        Icons.event_outlined,
                        color: primary.withOpacity(0.4),
                        size: 30,
                      )),
                  firstDate: DateTime(2024, 5, 1),
                  lastDate: DateTime.now(),
                  onChanged: (val) {
                    daySelected = DateTime.parse(val);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                if (isExpense)
                  showPicker(
                    context: context,
                    value: timeSelected,
                    sunrise: const TimeOfDay(hour: 6, minute: 0), // optional
                    sunset: const TimeOfDay(hour: 18, minute: 0), // optional
                    duskSpanInMinutes: 120, // optional
                    onChange: (Time val) {
                      timeSelected = val;
                    },
                    isOnChangeValueMode: true,
                    isInlinePicker: true,
                    contentPadding: EdgeInsets.zero,
                    dialogInsetPadding: EdgeInsets.zero,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
