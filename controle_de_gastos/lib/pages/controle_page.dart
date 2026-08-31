import 'package:controle_de_gastos/enums/category_type.dart';
import 'package:controle_de_gastos/widgets/expense_tile.dart';
import 'package:controle_de_gastos/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:controle_de_gastos/models/expense.dart';
import 'package:controle_de_gastos/pages/historic_page.dart';

import 'dart:math';

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  // Controladores funcionam como ponte entre o widget de entrada de texto (TextField) e o código Dart, permitindo ler e manipular o conteúdo digitado pelo usuário.
  final TextEditingController descriptionController = TextEditingController(); // Controlador para ler o campo de descrição do gasto
  final TextEditingController amountController =
      TextEditingController(); // Controlador para ler o campo de valor do gasto

  // Categoria padrão selecionada no Dropdown
  CategoryType _selectedCategory = CategoryType.alimentacao;

  // Lista que vai armazenar todos os gastos
  List<Expense> expenses = [];

  // Extrai apenas valores numéricos válidos (com ou sem casas decimais) de uma string.
  // Utiliza Expressões Regulares (RegExp) para ignorar letras e caracteres especiais,
  // garantindo a conversão do texto digitado para double.
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

  // Lê os campos de entrada, trata a formatação de vírgula para ponto e
  // adiciona um novo registro no início (topo) da lista de gastos.
  // Também limpa os campos de texto após a inserção bem-sucedida.
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

  // Calcula o valor total de todos os gastos registrados na lista.
  // O método .fold itera sobre a lista somando os valores de forma eficiente.
  double calcularTotal() {
    return expenses.fold(0.0, (soma, item) => soma + item.amount);
    //O .fold percorre a lista e acumula o valor total dos gastos, iniciando com 0.0 e somando cada valor dos items.
  }

  // Filtra a lista de gastos por uma categoria específica usando .where()
  // e em seguida soma o valor total apenas dos itens filtrados.
  double totalCategoria(CategoryType categoria) {
    return expenses
        .where((item) => item.category == categoria)
        .fold(0.0, (soma, item) => soma + item.amount);
    //O .where filtra os itens da lista que correspondem à categoria especificada, e o .fold soma os valores desses itens filtrados.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar com título e botão para acessar a tela de histórico de gastos
      appBar: AppBar(
        title: Text(
          "Controle de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricPage(
                    expenses: expenses,
                    onDeleteExpense: (gastoParaRemover) {
                      setState(() {
                        expenses.remove(gastoParaRemover);
                      });
                    },
                  ),
                ),
              ).then((_) {
                // Atualiza a tela principal (os cartões de totais)
                // quando o usuário retorna da tela de histórico.
                setState(() {});
              });
            },
            icon: Icon(Icons.pie_chart),
          ),
        ],
        backgroundColor: Colors.green,
      ),

      // Conteúdo principal da página
      body: SingleChildScrollView(
        child: Padding(
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
                  // DropdownButton para selecionar a categoria do gasto, preenchido com os valores do enum CategoryType.
                  DropdownButton<CategoryType>(
                    value: _selectedCategory,
                    // Cria uma lista de DropdownMenuItem para cada categoria do enum CategoryType.
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

              // Lista de gastos limitada a 7 itens, com opção de exclusão de cada gasto
              ListView.builder(
                shrinkWrap:
                    true, // Faz a lista ocupar apenas o tamanho dos itens
                physics: const NeverScrollableScrollPhysics(), // Desativa a rolagem da lista (pois a tela toda já vai rolar)
                // Limita a exibição a 7 itens usando a função min() da biblioteca dart:math para garantir que não ultrapasse o tamanho da lista de gastos.
                itemCount: min(expenses.length, 7),
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
            ],
          ),
        ),
      ),
    );
  }
}
