import 'dart:convert';

import 'package:listatarefas/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = 'todo_list';

//sharedPreferences é usado para armazenar pequenos dados.. evitando que toda vez que inicializa uma aplicação os dados salvos sejam perdidos
class TodoRepositories {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //para evitar o erro de tipo de variavel que retonr, considera que ela pode ser retornado como null
    //ou use a logica de retorna uma lista vazia usando  ?? '{}'.
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '{}';
    //fazendo que o arquivo json seja convertido em uma list
    final List jsonDecoded = json.decode(jsonString) as List;
    //convertendo as informaçoes armazenadas em json novamente em uma list
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    //json.encode é comando para converter dados em json/texto
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
