import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/service/databaseFirestore.dart';
import 'package:todolist/update.dart';
import 'addtask.dart';

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
      home: const home(),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _HomeState();
}

class _HomeState extends State<home> {
  Stream<QuerySnapshot>? taskStream;

  @override
  void initState() {
    super.initState();
    taskStream = FirebaseFirestore.instance.collection('Task').snapshots();
  }

  Widget allTasks() {
    return StreamBuilder<QuerySnapshot>(
      stream: taskStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return TaskTile(
              taskId: ds.id,
              taskName: ds['Task Name'],
              taskDescription: ds['Task description'],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ToDo List',
              style: TextStyle(color: Colors.white, fontFamily: 'sans'),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: allTasks(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddingTasks()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final String taskId;
  final String taskName;
  final String taskDescription;

  const TaskTile({
    Key? key,
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskName,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 10),
          Text(
            taskDescription,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Update(
                        taskId: taskId,
                        initialTaskName:taskName,
                        initialTaskDescription: taskDescription,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.edit, color: Colors.blue),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () async {
                  print('Deleting task with ID: $taskId'); // Debug print statement
                  await DatabaseMethods().deleteTask(taskId);
                },
                child: Icon(Icons.delete, color: Colors.red),

          ),
              ],)
        ],
      ),
    );
  }
}
