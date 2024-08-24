import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:todolist/home.dart';
import 'package:todolist/service/databaseFirestore.dart';
import 'package:todolist/service/sqldb.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AddingTasks(),
    );
  }
}

class AddingTasks extends StatefulWidget {
  const AddingTasks({super.key});

  @override
  State<AddingTasks> createState() => _AddingTasksState();
}

class _AddingTasksState extends State<AddingTasks> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController taskDescriptionController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tasks'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  SizedBox(width: 16),
                  Text('Task name', style: TextStyle(fontSize: 25)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 229, 229, 234),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  SizedBox(width: 16),
                  Text('Description', style: TextStyle(fontSize: 25)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: taskDescriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 229, 229, 234),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  ),
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    if(taskController.text.isNotEmpty&&taskDescriptionController.text.isNotEmpty) {
                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> taskInformation = {
                        "Task Name": taskController.text,
                        "Task description": taskDescriptionController.text,
                        "id": id,
                      };
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const home()),);
                      await DatabaseMethods().addTask(taskInformation, id);
                      sqlDb.insertData(
                        "INSERT INTO users (Task, description) VALUES (?, ?)",
                        [taskController, taskDescriptionController],
                      );

                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('add tasks failed. Please try again.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 120, 205),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
