import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenso/Models/Budget.dart';
import 'package:expenso/Models/Expense.dart';

class FirestoreHelper {
  static Future<List<Expense>> getDailyExpensesByDate(
      String email, DateTime date) async {
    DateTime daySelected = DateTime(date.year, date.month, date.day);
    final expneses = await FirebaseFirestore.instance
        .collection('daily_expenses')
        .doc(email)
        .collection('expenses')
        .where('date', isGreaterThanOrEqualTo: daySelected)
        .where(
          'date',
          isLessThanOrEqualTo: daySelected.add(
            Duration(days: 1),
          ),
        )
        .get();
    List<Expense> res = List.empty(growable: true);
    for (QueryDocumentSnapshot doc in expneses.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      res.add(Expense.fromJson(data));
    }
    return res;
  }

  static Future<List<Expense>> getAllDailyExpenses(String email) async {
    final expneses = await FirebaseFirestore.instance
        .collection('daily_expenses')
        .doc(email)
        .collection('expenses')
        .get();
    List<Expense> res = List.empty(growable: true);
    for (QueryDocumentSnapshot doc in expneses.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      res.add(Expense.fromJson(data));
    }
    return res;
  }

  static Future<void> insertExpense(String email, Expense expe) async {
    await FirebaseFirestore.instance
        .collection('daily_expenses')
        .doc(email)
        .collection('expenses')
        .add(expe.toJson());
  }

  static Future<void> insertBudget(String email, Budget budget) async {
    await FirebaseFirestore.instance
        .collection('budgets')
        .doc(email)
        .collection('budgets')
        .add(budget.toJson());
  }

  static Future<List<Budget>> _getBudgetByDate(
      String email, DateTime date) async {
    DateTime daySelected = DateTime(date.year, date.month, date.day);
    final budgets = await FirebaseFirestore.instance
        .collection('budgets')
        .doc(email)
        .collection('budgets')
        .where('date', isGreaterThanOrEqualTo: daySelected)
        .where(
          'date',
          isLessThanOrEqualTo: daySelected.add(
            Duration(days: 1),
          ),
        )
        .get();
    List<Budget> res = List.empty(growable: true);
    for (QueryDocumentSnapshot doc in budgets.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      res.add(Budget.fromJson(data));
    }
    return res;
  }

  static Future<List<Budget>> getBudgetByDateWithPriceRatio(
      String email, DateTime date) async {
    final expenses = await getDailyExpensesByDate(email, date);
    final budgets = await _getBudgetByDate(email, date);
    print("#######################################");
    print("#######################################");
    for (Expense exp in expenses) {
      for (Budget budget in budgets) {
        if (exp.cat == budget.cat) {
          budget.taken += exp.price;
        }
      }
    }
    return budgets;
  }
}
