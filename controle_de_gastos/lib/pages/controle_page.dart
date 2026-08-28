import 'package:controle_de_gastos/enums/category_type.dart';
import 'package:controle_de_gastos/widgets/expense_tile.dart';
import 'package:controle_de_gastos/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:controle_de_gastos/models/expense.dart';

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
              amount: "0,00",
              color: Colors.red,
            ),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.alimentacao.label,
                    amount: "0,00",
                    color: CategoryType.alimentacao.color,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.transporte.label,
                    amount: "0,00",
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
                    amount: "0,00",
                    color: CategoryType.lazer.color,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: CategoryType.outros.label,
                    amount: "0,00",
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
                  onPressed: () {},
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
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ExpenseTile(
                    description: "almoço",
                    amount: "35,00",
                    categoryName: CategoryType.alimentacao.label,
                    categoryColor: CategoryType.alimentacao.color,
                    onDelete: () {},
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
