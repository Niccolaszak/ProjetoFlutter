import 'package:flutter/material.dart';

// Enumeração (Enum) utilizada para classificar os tipos de gastos padronizados do sistema.
// Utiliza o recurso de "Enhanced Enums" do Dart para associar propriedades visuais (cor) 
// e textuais (rótulo) diretamente a cada constante, simplificando a interface.
enum CategoryType {
  alimentacao(label: 'Alimentação', color: Colors.orange),
  transporte(label: 'Transporte', color: Colors.blue),
  lazer(label: 'Lazer', color: Colors.purple),
  outros(label: 'Outros', color: Colors.grey);

  // Propriedades imutáveis atreladas a cada opção do enum.
  // 'label' é exibido nos textos da tela e 'color' define a identidade visual da categoria.
  final String label;
  final Color color;

  // Construtor constante (const) que exige a definição do rótulo e da cor 
  // no momento em que cada item do enum é declarado lá em cima.
  const CategoryType({required this.label, required this.color});
}
