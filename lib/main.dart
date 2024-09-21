import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/home_view.dart';
import 'package:todo_app/view_model/todo_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const HomeView(),
      ),
    );
  }
}
