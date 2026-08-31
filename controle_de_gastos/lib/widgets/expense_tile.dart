import 'package:flutter/material.dart';



// Widget customizado reutilizável que representa a interface de um único gasto na lista.
// Por ser um StatelessWidget, ele apenas recebe os dados e os desenha na tela.
class ExpenseTile extends StatelessWidget {
  // Recebe os dados visuais do gasto e uma função de callback (VoidCallback).
  // O callback permite que o tile avise a tela principal quando o botão de deletar for confirmado.
  final String description;
  final String amount;
  final String categoryName;
  final Color categoryColor;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.description,
    required this.amount,
    required this.categoryName,
    required this.categoryColor,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor,
          child: Icon(Icons.receipt_long, color: Colors.white),
        ),
        title: Text(description),
        subtitle: Text(categoryName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "R\$ $amount",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                // Abre um pop-up (Dialog) para evitar exclusões acidentais.
                // O Navigator.pop devolve 'false' para Cancelar e 'true' para Excluir.
                showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                    title: Text("Excluir Gasto"),
                    content: Text("Tem certeza que deseja excluir este gasto?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )),
                ).then((confirmado) {
                  // Captura o retorno do Dialog. Se o usuário confirmou (true),
                  // dispara a função de exclusão passada lá pela tela principal/histórico.
                  if (confirmado == true) {
                    onDelete();
                  }
                });
              },
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
