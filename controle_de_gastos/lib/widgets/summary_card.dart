import 'package:flutter/material.dart';

// Widget customizado e reutilizável responsável por exibir os painéis de resumo de gastos.
// É utilizado tanto para o Total Geral quanto para os subtotais de cada categoria.
class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  // A largura é opcional (anotada com o '?'). Isso permite que o cartão 
  // seja flexível e se adapte a diferentes layouts (ex: em tela cheia ou em colunas)
  final double? width;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Operador '??': se a largura for informada, usa ela. 
      // Se for nula, expande para ocupar o espaço máximo disponível (double.infinity).
      width: width ?? double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        // Utiliza a cor passada por parâmetro (cor da categoria), 
        // aplicando uma transparência de 10% (alpha: 0.1) para criar um fundo suave.
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "R\$ $amount",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
