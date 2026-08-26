import 'package:flutter/material.dart';

class ControlePage extends StatefulWidget {
  const new({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("Controle de Gastos",
            style: TextStyle(fontWeight: FontWeight.bold,)
        ),
        backgroundColor: Colors.lightGreen,
      )
    );
  }
}
