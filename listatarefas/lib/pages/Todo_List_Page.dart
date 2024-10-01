import 'package:flutter/material.dart';
import 'package:listatarefas/models/todo.dart';
import 'package:listatarefas/repositorio/todo_repositorio.dart';
import 'package:listatarefas/widget/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepositories todoRepositories = TodoRepositories();

  List<Todo> todos = [];
  //armazena as tarefas deletadas
  Todo? deleteTodo;
  //retorna as tarefas par os mesmo locais de onde ela foi deletada, no caso se foi em uma lista e a tarefa 4 foi deletada, assim que desfeito ela retorna par ao mesmo lugar
  int? deleteTodoPos;

  String? errorText;

// o metodo initState nesse caso é executado uma vez fazendo com que carregue as informações salvas
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoRepositories.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Adicione uma Tarefa",
                          hintText: "Ex. Estudar",
                          errorText: errorText,
                          //alterando a cor assim que clicado para fazer o input
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff00d7f3),
                              width: 2,
                            ),
                          ),
                          // alterando a cor do texto da box de input
                          labelStyle: TextStyle(
                            color: Color(0xff00d7f3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = " O titulo não pode ser vazio.";
                          });

                          return;
                        }

                        setState(() {
                          //capturando o horario atual e colocando em cada tarefa
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          // é atribuido para sumir com a mensagem de error
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepositories.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          //pasando a função delete para a lista
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você Possui ${todos.length} Tarefas pendentes",
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfimationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        "Limpar tudo",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    //salvando o item deletado
    deleteTodo = todo;
    // verificando a aposição da tarefa
    deleteTodoPos = todos.indexOf(todo);
    setState(
      () {
        todos.remove(todo);
      },
    );
    // o mesmo para delete
    todoRepositories.saveTodoList(todos);
    //esse é para caso apareça varias mensagem e n de erro no cod.. ele vai deletando
    ScaffoldMessenger.of(context).clearSnackBars();
    //mensagem que aparece depois que o item foi apagado
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${todo.title} foi removida com sucesso",
          style: const TextStyle(
            color: Color(0xff060708),
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Color(0xff00d7f3),
          onPressed: () {
            //setState para atualizar a tela
            setState(
              () {
                //ponot de ! para afirmar que os itens não podem ser nulos, pois no topo eles estão como ? podendo receber nulos, e aqui eles n podem ser nulos
                todos.insert(deleteTodoPos!, deleteTodo!);
              },
            );
            // para que a atividade deletar não seja desfeita apos reiniciar o app.. é atrabuido a execução dentro do todorepositorie
            todoRepositories.saveTodoList(todos);
          },
        ),
        //duração da mensagem
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfimationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("limpar tudo?"),
        content: Text("Você tem certeza que deseja limpar todas as tarefas"),
        actions: [
          TextButton(
            onPressed: () {
              //fecha o dialogo
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              // para colocar cor no texto do botão, usasse o foregorundColor
              foregroundColor: Color(0xff00d7f3),
            ),
            child: Text("cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text("Limpar tudo"),
          ),
        ],
      ),
    );
  }

//limpar a lista inteira
  void deleteAllTodos() {
    setState(
      () {
        todos.clear();
      },
    );
    // o mesmo para deletar tudo
    todoRepositories.saveTodoList(todos);
  }
}
