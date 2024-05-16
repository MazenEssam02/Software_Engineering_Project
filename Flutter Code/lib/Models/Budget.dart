
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenso/Models/Expense_Category.dart';
import 'package:intl/intl.dart';

class Budget {
  Budget(
      {required this.originalPrice,
      required this.date,
      required this.cat,
      this.taken = 0});

  num originalPrice;
  num taken;
  ExpenseCategory cat;
  Timestamp date;
  String getFormattedTime() {
    return DateFormat('hh:mm a').format(date.toDate());
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(date.toDate());
  }

  double getRatio() {
    return (taken / originalPrice);
  }

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        originalPrice: json["price"],
        cat: ExpenseCategory.getExpenseCategoryFromString(json["category"]),
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "price": originalPrice,
        "category": cat.name,
        "date": date,
      };
}
