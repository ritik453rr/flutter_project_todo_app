import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/data_model.dart';

class AddPage extends StatefulWidget {
  final DataModel? todo;
  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo.title.toString();
      descriptionController.text = todo.description.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEdit ? "Edit Todo" : "Add Todo",
        ),
      ),
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                isEdit ? updateData() : submitData();
              },
              child: Text(
                isEdit ? "Update" : "Submit",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Update data from sever using put method
  Future<void> updateData() async {
    //get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print("You cant call updated without todo data");
      return;
    }
    final id = todo.sId;
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //submit data to the server
    final response = await http.put(
      Uri.parse('https://api.nstack.in/v1/todos/$id'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    //show success or fail message based on the status
    if (response.statusCode == 200) {
      showSuccessMessage("Updation Success");
      print(response.body);
    } else {
      showErrorMessage('Updation Failed');
    }
  }

  //Function to submit data on the server using post method
  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final response = await http.post(
      Uri.parse('https://api.nstack.in/v1/todos'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    //show success or fail message based on the status
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage("Creation Successfull");
    } else {
      showErrorMessage('Creation Failed');
    }
  }
 
  //show successMessage
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

//show error
  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
