import 'package:flutter/material.dart';
import 'package:todo_app/model/toto_model.dart';
import 'package:todo_app/repository/todo_repo.dart';

class TodoViewModel extends ChangeNotifier {
  TodoRepo todoRepo = TodoRepo();

  late Future<List<TodoModel>> todoList;

    void fetchTodoList(){
    todoList =  todoRepo.getTodoList();
    notifyListeners();
  }

  Future<void> deleteTodo(String todoId) async {
    await todoRepo.deleteTodo(todoId);
  }

  Future<void> updateTodo(
      {required String todoId,
      required String title,
      required String description}) async {
    await todoRepo.updateTodo(
        title: title, description: description, id: todoId);
  }

}
