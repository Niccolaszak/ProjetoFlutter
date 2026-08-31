import 'package:controle_de_gastos/enums/category_type.dart';
import 'package:controle_de_gastos/models/expense.dart';
import 'package:controle_de_gastos/widgets/expense_tile.dart';
import 'package:flutter/material.dart';

class HistoricPage extends StatefulWidget {

  // Recebe a lista de gastos e a função de exclusão diretamente da tela principal (ControlePage).
  // Isso garante que ambas as telas manipulem os mesmos dados.
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
    // Lógica principal de filtragem: 
    // Se o filtro for nulo, a lista exibe todos os gastos originais.
    // Caso contrário, utiliza o método .where() para criar uma nova lista contendo 
    // apenas os itens cuja categoria seja igual à selecionada no Dropdown.
    final gastosFiltrados = filtroCategoria == null
        ? widget.expenses
        : widget.expenses
              .where((gasto) => gasto.category == filtroCategoria)
              .toList();

    return Scaffold(
      // AppBar igual a da tela principal, mudando apenas o título.
      appBar: AppBar(
        title: Text(
          "Historico de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      // Corpo da tela: coluna com o Dropdown de filtro e a lista de gastos filtrados.
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
                // DropdownButton para selecionar a categoria do gasto, preenchido com os valores do enum CategoryType.
                DropdownButton<CategoryType>(
                  value: filtroCategoria,
                  hint: Text("Todas"),
                  items: [
                    // Adiciona uma opção "Todas" para permitir que o usuário veja todos os gastos sem filtro.
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        "Todas",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Cria um DropdownMenuItem para cada categoria do enum CategoryType,
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
                    // Atualiza o estado com a nova categoria selecionada, 
                    // forçando a tela a ser reconstruída com a lista filtrada.
                    setState(() {
                      filtroCategoria = novoValor;
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(),

          // A lista de gastos filtrados é exibida abaixo do Dropdown.
          // Se a lista estiver vazia, exibe uma mensagem informando que não há gastos na categoria selecionada.
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
                          // Chama a função passada por parâmetro para deletar o item
                          // na lista original (na tela principal) e reconstrói o histórico
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
