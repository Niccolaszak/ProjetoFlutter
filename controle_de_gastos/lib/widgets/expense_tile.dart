import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
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
            IconButton(onPressed: onDelete, icon: Icon(Icons.delete, color: Colors.red,))
          ],
        ),
      ),
    );
  }
}
