import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// Importar o intl para formatar a data e hora
import 'package:intl/intl.dart';
import 'package:listatarefas/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Slidable(
            key: ValueKey(todo.title), // Use a unique key for each item
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  //ação de delete
                  onPressed: (context) {
                    onDelete(todo);
                  },
                  //customização do slide
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  //substitui o .start pelo .strech para que ele ocupasse o maior espaço dentro do conteiner,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      DateFormat("dd/MM/yyyy").format(todo.dateTime),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
