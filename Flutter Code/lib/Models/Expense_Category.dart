import 'package:flutter/material.dart';

enum ExpenseCategory {
  auto("Auto", "assets/images/auto.png", Colors.purpleAccent),
  bank("Bank", "assets/images/bank.png", Colors.blueAccent),
  cash("Cash", "assets/images/cash.png", Colors.greenAccent),
  charity("Charity", "assets/images/charity.png", Colors.yellowAccent),
  eating("Eating", "assets/images/eating.png", Colors.pinkAccent),
  gift("Gift", "assets/images/gift.png", Colors.redAccent);

  const ExpenseCategory(this.name, this.path, this.color);
  final String name;
  final String path;
  final Color color;
  static getExpenseCategoryFromString(String label) {
    switch (label) {
      case "Auto":
        return ExpenseCategory.auto;
      case "Bank":
        return ExpenseCategory.bank;

      case "Cash":
        return ExpenseCategory.cash;
      case "Charity":
        return ExpenseCategory.charity;
      case "Eating":
        return ExpenseCategory.eating;
      case "Gift":
        return ExpenseCategory.gift;
      default:
        return ExpenseCategory.auto;
    }
  }
}
