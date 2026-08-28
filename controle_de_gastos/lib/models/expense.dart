import 'package:controle_de_gastos/enums/category_type.dart';

class Expense {
  final String description;
  final double amount;
  final CategoryType category;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
  });
}