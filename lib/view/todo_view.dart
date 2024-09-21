import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/toto_model.dart';
import 'package:todo_app/view_model/todo_view_model.dart';
import 'dart:async'; // For debouncing

class TodoView extends StatefulWidget {
  final TodoModel? todo;
  const TodoView({super.key, required this.todo});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  Timer? _debounce; // Debounce Timer

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Debounce method to optimize the API calls
  void _onFieldChanged(BuildContext context, String title, String description) {
    if (_debounce?.isActive ?? false) {
      print("bouncing....");
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(seconds: 1), () async {
      await Provider.of<TodoViewModel>(context, listen: false).updateTodo(
        title: title,
        description: description,
        todoId: widget.todo!.sId.toString(),
      );
        Provider.of<TodoViewModel>(context, listen: false).fetchTodoList();
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            // Title TextField
            TextField(
              onChanged: (value) {
                _onFieldChanged(context, value, descriptionController.text);
              },
              controller: titleController,
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title',
              ),
            ),
            const SizedBox(height: 10),
            // Description TextField
            TextField(
              onChanged: (value) {
                _onFieldChanged(context, titleController.text, value);
              },
              controller: descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter description',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
