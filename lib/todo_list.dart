import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app/add_page.dart';
import 'package:todo_app/data_model.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<DataModel> items = [];
  bool isLoading = true;
  @override
  void initState() {
    fetchToDo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      body: Visibility(
        visible: !isLoading,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(
            child: Text(
              "No Todo Item",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(items[index].title.toString()),
                  subtitle: Text(items[index].description.toString()),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        navigateToEditPage(items[index]);
                      } else if (value == 'delete') {
                        deleteById(id: items[index].sId.toString());
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            "Edit",
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            "Delete",
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //navigate to add page
  Future<void> navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPage(),
      ),
    );
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  //Function to navigate to edit page
  Future<void> navigateToEditPage(DataModel item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(todo: item),
      ),
    );
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  //Function to fetch Todo List from server
  Future<void> fetchToDo() async {
    final response = await http.get(
      Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=20'),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      items = [];
      for (Map i in result) {
        items.add(DataModel.fromJson(i));
      }
    } else {
      showErrorMessage(
        message: 'Something went wrong',
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  //Function to Delete resourse from server and List
  Future<void> deleteById({required String id}) async {
    final response =
        await http.delete(Uri.parse("https://api.nstack.in/v1/todos/$id"));
    if (response.statusCode == 200) {
      setState(() {
        items.removeWhere((element) => element.sId == id);
      });
    } else {
      showErrorMessage(message: "Failed to deletion");
    }
  }

  //show snackbar
  void showErrorMessage({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
