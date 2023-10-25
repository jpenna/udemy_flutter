import 'package:first_app/models/expense.dart';
import 'package:first_app/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onDismissExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onDismissExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          child: Container(
            child: Text('Erase'),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 30),
          ),
        ),
        onDismissed: (DismissDirection direction) {
          onDismissExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
