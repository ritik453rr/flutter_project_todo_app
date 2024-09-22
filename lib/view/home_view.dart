import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/view/add_todo_view.dart';
import 'package:todo_app/view/todo_view.dart';
import 'package:todo_app/view_model/todo_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    Provider.of<TodoViewModel>(context, listen: false).fetchTodoList();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Floating Add todo button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoView(),
            ),
          );
        },
        label: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Container(
              height: screenHeight * 0.076,
              width: screenWidth * 0.91,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Icon(Icons.search, size: 25),
                  ),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search notes",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Todo List using FutureBuilder
          Consumer<TodoViewModel>(
            builder: (context, todoProvider, child) {
              return FutureBuilder<List<TodoModel>>(
                future: todoProvider.todoList,
                builder: (context, snapshot) {
                  // Waiting state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Expanded(
                      child: Center(
                        child: Text("Error Loading Data"),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          "Empty",
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final List<TodoModel>? todoList = snapshot.data;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: ListView.builder(
                          itemCount: todoList?.length ?? 0,
                          itemBuilder: (context, index) {
                            final TodoModel? todo = todoList?[index];
                            if (todo == null) {
                              return Container(); // Safety check
                            }
                            // Todo Card
                            return Card(
                              color: Colors.grey.withOpacity(0.2),
                              elevation: 5,
                              child: Consumer<TodoViewModel>(
                                builder: (context, todoProvider, child) {
                                  return ListTile(
                                    //View Todo.........
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TodoView(
                                            todo: todo,
                                          ),
                                        ),
                                      );
                                    },
                                    //Deleting todo....
                                    onLongPress: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Delete Todo"),
                                            content:
                                                Text("sure to delete todo?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                
                                                },
                                                child: Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await todoProvider.deleteTodo(
                                                      todo.sId.toString());
                                                  todoProvider.fetchTodoList();
                                                },
                                                child: Text("Yes"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    //Todo title....
                                    title: Text(
                                      todo.title ?? 'No Title',
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      todo.description ?? 'No Description',
                                      maxLines: 1,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
