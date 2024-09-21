import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/repository/todo_repo.dart';
import 'package:todo_app/view_model/todo_view_model.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TodoRepo todoRepo = TodoRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          //Title....
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          //Description
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Discription'),
            keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 5,
          ),
          const SizedBox(
            height: 18,
          ),
          //Submit button
          SizedBox(
            height: 40,
            child: Consumer<TodoViewModel>(
              builder: (context, todoProvider, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    await todoRepo.postTodo(
                      title: titleController.text,
                      description: descriptionController.text,
                    );
                    todoProvider.fetchTodoList();
                    titleController.text = "";
                    descriptionController.text = "";
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
