import 'package:controle_de_gastos/enums/category_type.dart';
import 'package:controle_de_gastos/models/expense.dart';
import 'package:controle_de_gastos/widgets/expense_tile.dart';
import 'package:flutter/material.dart';

class HistoricPage extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onDeleteExpense;
  const HistoricPage({super.key, required this.expenses, required this.onDeleteExpense});

  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  CategoryType? filtroCategoria;

  @override
  Widget build(BuildContext context) {
    final gastosFiltrados = filtroCategoria == null
        ? widget.expenses
        : widget.expenses
              .where((gasto) => gasto.category == filtroCategoria)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Historico de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filtrar por: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<CategoryType>(
                  value: filtroCategoria,
                  hint: Text("Todas"),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        "Todas",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...CategoryType.values.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria,
                        child: Text(
                          categoria.label,
                          style: TextStyle(
                            color: categoria.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                  onChanged: (novoValor) {
                    setState(() {
                      filtroCategoria = novoValor;
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(),

          Expanded(
            child: gastosFiltrados.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum gasto encontrato nessa categoria.",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: gastosFiltrados.length,
                    itemBuilder: (context, index) {
                      final gasto = gastosFiltrados[index];

                      return ExpenseTile(
                        description: gasto.description,
                        amount: gasto.amount
                            .toStringAsFixed(2)
                            .replaceAll(".", ","),
                        categoryName: gasto.category.label,
                        categoryColor: gasto.category.color,
                        onDelete: () {
                          widget.onDeleteExpense(gasto);
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
