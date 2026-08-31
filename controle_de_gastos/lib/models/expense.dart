import 'package:controle_de_gastos/enums/category_type.dart';

// Classe de modelo (Model) que representa a estrutura de um único gasto financeiro.
// Serve para agrupar as informações (descrição, valor e categoria) em um único objeto.
class Expense {
  // Atributos definidos como 'final' para garantir que os dados não sejam mudados.
  // Uma vez que o gasto é criado, seus valores não podem ser alterados acidentalmente.
  final String description;
  final double amount;
  final CategoryType category;

  // Construtor da classe com parâmetros nomeados. 
  // O uso da palavra-chave 'required' obriga que todas as três informações 
  // sejam fornecidas sempre que um novo gasto for inserido.
  Expense({
    required this.description,
    required this.amount,
    required this.category,
  });
}