import 'package:flutter/material.dart';
import 'package:todolist/service/databaseFirestore.dart';

import 'home.dart';

class Update extends StatefulWidget {
  final String taskId;
  final String initialTaskName;
  final String initialTaskDescription;

  const Update({
    Key? key,
    required this.taskId,
    required this.initialTaskName,
    required this.initialTaskDescription,
  }) : super(key: key);

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late TextEditingController taskController;
  late TextEditingController taskDescriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing task data
    taskController = TextEditingController(text: widget.initialTaskName);
    taskDescriptionController = TextEditingController(text: widget.initialTaskDescription);
  }

  @override
  void dispose() {
    taskController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
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
                  style: const TextStyle(color: Colors.black, fontSize: 16),
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
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> updatedTaskInformation = {
                      "Task Name": taskController.text,
                      "Task description": taskDescriptionController.text,
                    };
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const home()),);
                    await DatabaseMethods().updateTask(widget.taskId, updatedTaskInformation);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 120, 205),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
