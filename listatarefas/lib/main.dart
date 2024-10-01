import 'package:flutter/material.dart';
import 'package:listatarefas/pages/Todo_List_Page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //para tirar a faixa de debug no canto do app
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
    );
  }
}
