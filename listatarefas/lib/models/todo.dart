class Todo {
  Todo({
    required this.title,
    required this.dateTime,
  });

  String title;
  DateTime dateTime;
//segundo construtor para o arquivo json
  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? "",
        //atualização do cod.. fazendo com que o erro '_TypeError (type 'Null' is not a subtype of type 'String')'
        //solução.. faer uma verificação onde se retornar null. sera atribuido um valo padão com base na hora atual
        dateTime = json['dateTime'] != null
            ? DateTime.parse(json['dateTime'])
            : DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      //transformando o datetime em string, pois no json não recebe valores que não sejam no formato primitivo
      'datetime': dateTime.toIso8601String(),
    };
  }
}
