import 'package:flutter/material.dart';

enum CategoryType {
  alimentacao(label: 'Alimentação', color: Colors.orange),
  transporte(label: 'Transporte', color: Colors.blue),
  lazer(label: 'Lazer', color: Colors.purple),
  outros(label: 'Outros', color: Colors.grey);

  final String label;
  final Color color;

  const CategoryType({required this.label, required this.color});
}
