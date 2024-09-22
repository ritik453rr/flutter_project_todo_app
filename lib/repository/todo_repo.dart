import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/res/app_url.dart';
import 'package:todo_app/services/rest_api_services.dart';

class TodoRepo {
  RestApiServices restApiServices = RestApiServices();

  //Get todo
  Future<List<TodoModel>> getTodoList() async {
    try {
      dynamic jsonData = await restApiServices.getRequest(AppUrl.todoGetUrl);
      List<TodoModel> tempLists = [];
      for (var i in jsonData["items"]) {
        tempLists.add(TodoModel.fromJson(i));
      }
      return tempLists;
    } catch (e) {
      rethrow;
    }
  }

  //post todo
  Future<void> postTodo(
      {required String title, required String description}) async {
   await restApiServices.postRequest(
        postUrl: AppUrl.todoPostUrl, title: title, description: description);
  }

  //update
  Future<void> updateTodo(
      {required String? title,
      required String? description,
      required String id}) async {
    await restApiServices.putRequest(
        putUrl: AppUrl.todoPutUrl,
        title: title,
        description: description,
        id: id);
  }

  //delete todo
  Future<void> deleteTodo(String todoId) async {
    await restApiServices.deleteRequest(deleteUrl: AppUrl.todoDeleteUrl, id: todoId);
  }

}
