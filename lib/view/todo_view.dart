import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo_model.dart';
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
  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  // Debounce method to optimize the API calls
  Future<void> onFieldChanged(
      {required BuildContext context,
      required String title,
      required String description}) async {
    if (_debounce?.isActive ?? false) {
      print("typing....");
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        saving = true;
      });
      await Provider.of<TodoViewModel>(context, listen: false).updateTodo(
        title: title,
        description: description,
        todoId: widget.todo!.sId.toString(),
      );
      await Provider.of<TodoViewModel>(context, listen: false).fetchTodoList();
      setState(() {
        saving = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: saving ? const Text("saving...") : const Text("saved"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            // Title TextField
            TextField(
              onChanged: (value) async {
                await onFieldChanged(
                    context: context,
                    title: titleController.text,
                    description: descriptionController.text);
              },
              controller: titleController,
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title',
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            // Description TextField
            TextField(
              onChanged: (value) async {
                await onFieldChanged(
                    context: context,
                    title: titleController.text,
                    description: descriptionController.text);
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
