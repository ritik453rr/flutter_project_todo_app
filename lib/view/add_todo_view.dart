import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view_model/todo_view_model.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("build method called");
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Set visibility to false when back button is pressed
        Provider.of<TodoViewModel>(context, listen: false).setVisibility(false);
        // Allow the pop to happen
        return true;
      },
      child: Consumer<TodoViewModel>(
        builder: (context, todoProvider, child) => Scaffold(
          appBar: AppBar(
            actions: [
              todoProvider.checkedVisibility
                  ?
                  //Check Button
                  Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () async {
                          //Checking if title is empty..
                          if (titleController.text.isEmpty) {
                            // Show a dialog if the title is empty
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Title is empty"),
                                  content: const Text(
                                      "Please enter a title before saving."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            return; // Exit the function if the title is empty
                          }
                          // Proceed with the normal flow if the title is not empty
                          todoProvider.setVisibility(false);
                          try {
                            await todoProvider.postTodo(
                              title: titleController.text,
                              description: descriptionController.text,
                            );
                            // Show a success SnackBar after the data is successfully posted
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Added successfully!'),
                                backgroundColor: Colors
                                    .green, // Optional: Change the background color
                              ),
                            );
                            // Clear the text fields after successful submission
                            titleController.text = "";
                            descriptionController.text = "";
                            todoProvider.fetchTodoList();
                          } catch (error) {
                            // Handle error, e.g., show a different SnackBar for failure
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Failed to add todo. Please try again.'),
                                backgroundColor: Colors
                                    .red, // Optional: Change the background color
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                    )
                  : Container(),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Title TextField
              TextField(
                controller: titleController,
                onTap: () {
                  todoProvider.setVisibility(true);
                },
                style: const TextStyle(fontSize: 25),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter title',
                ),
              ),
              //Divider
              const Divider(
                color: Colors.white,
              ),
              // Description TextField
              TextField(
                onTap: () {
                  todoProvider.setVisibility(true);
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
      ),
    );
  }
}
