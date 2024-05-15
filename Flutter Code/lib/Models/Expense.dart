import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenso/Models/Expense_Category.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expense {
  Expense({
    required this.name,
    required this.price,
    required this.cat,
    required this.date,
  });

  String name;
  num price;
  ExpenseCategory cat;
  Timestamp date;

  String getFormattedTime() {
    return DateFormat('hh:mm a').format(date.toDate());
  }

  String getFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(date.toDate());
  }

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        name: json["name"],
        price: json["price"],
        cat: ExpenseCategory.getExpenseCategoryFromString(json["category"]),
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category": cat.name,
        "date": date,
      };
}
