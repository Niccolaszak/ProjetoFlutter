import 'package:controle_de_gastos/enums/category_type.dart';
import 'package:controle_de_gastos/widgets/expense_tile.dart';
import 'package:controle_de_gastos/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:controle_de_gastos/models/expense.dart';
import 'dart:math';

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  // Controladores para ler os TextFields
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Categoria padrão selecionada no Dropdown
  CategoryType _selectedCategory = CategoryType.alimentacao;

  // Lista que vai armazenar todos os gastos
  List<Expense> expenses = [];

  List<double> parseNumbers(String expression) {
    RegExp regExp = RegExp(r"[0-9]+\.?[0-9]*");

    var matches = regExp.allMatches(expression);
    List<double> numbers = [];

    for (var match in matches) {
      String numberText = match.group(0)!;
      numbers.add(double.parse(numberText));
    }

    return numbers;
  }

  void adicionarGasto() {
    final String descricao = descriptionController.text;
    final String valorTexto = amountController.text;

    if (descricao.isEmpty || valorTexto.isEmpty) return;

    String expression = valorTexto.replaceAll(',', '.');
    List<double> numbers = parseNumbers(expression);

    if (numbers.isEmpty) return;

    final double valor = numbers.first;

    if (valor <= 0) return;

    setState(() {
      expenses.insert(
        0,
        Expense(
          description: descricao,
          amount: valor,
          category: _selectedCategory,
        ),
      );
    });

    descriptionController.clear();
    amountController.clear();
  }

  //calcula o valor total dos gastos
  double calcularTotal() {
    return expenses.fold(0.0, (soma, item) => soma + item.amount);
  }

  double totalCategoria(CategoryType categoria) {
    return expenses
        .where((item) => item.category == categoria)
        .fold(0.0, (soma, item) => soma + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Controle de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.pie_chart))],
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SummaryCard(
              title: "Gasto Total",
              amount: calcularTotal().toStringAsFixed(2).replaceAll(".", ","),
              color: Colors.red,
            ),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.alimentacao.label,
                    amount: totalCategoria(CategoryType.alimentacao)
                        .toStringAsFixed(2)
                        .replaceAll(".", ","),
                    color: CategoryType.alimentacao.color,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.transporte.label,
                    amount: totalCategoria(CategoryType.transporte)
                        .toStringAsFixed(2)
                        .replaceAll(".", ","),
                    color: CategoryType.transporte.color,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.lazer.label,
                    amount: totalCategoria(CategoryType.lazer)
                        .toStringAsFixed(2)
                        .replaceAll(".", ","),
                    color: CategoryType.lazer.color,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.outros.label,
                    amount: totalCategoria(CategoryType.outros)
                        .toStringAsFixed(2)
                        .replaceAll(".", ","),
                    color: CategoryType.outros.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descrição",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Valor",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //adicionar dropdown para categorias
                DropdownButton<CategoryType>(
                  value: _selectedCategory,
                  items: CategoryType.values.map((CategoryType category) {
                    return DropdownMenuItem<CategoryType>(
                      value: category,
                      child: Text(
                        category.label,
                        style: TextStyle(
                          color: category.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (CategoryType? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                ElevatedButton.icon(
                  onPressed: adicionarGasto,
                  icon: Icon(Icons.add),
                  label: Text("Adicionar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            Divider(),
            SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: min(expenses.length,7),
                itemBuilder: (context, index) {
                  final gasto = expenses[index];

                  return ExpenseTile(
                    description: gasto.description,
                    amount: gasto.amount
                        .toStringAsFixed(2)
                        .replaceAll(".", ","),
                    categoryName: gasto.category.label,
                    categoryColor: gasto.category.color,
                    onDelete: () {
                      setState(() {
                        expenses.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
