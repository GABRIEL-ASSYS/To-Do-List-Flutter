import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Map<String, dynamic>> _todoItems = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _addTodoItem(String task, String description, String date, String time) {
    if (task.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
      setState(() {
        _todoItems.add({
          'task': task,
          'description': description,
          'date': date,
          'time': time,
          'completed': false,
        });
      });
      _taskController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _timeController.clear();
    }
  }

  void _toggleCompletion(int index) {
    setState(() {
      _todoItems[index]['completed'] = !_todoItems[index]['completed'];
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Marcar "${_todoItems[index]['task']}" como concluído'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(_todoItems[index], index);
      },
    );
  }

  Widget _buildTodoItem(Map<String, dynamic> todoItem, int index) {
    return ListTile(
      title: Text(
        todoItem['task'],
        style: TextStyle(
          decoration: todoItem['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: Text(
        '${todoItem['description']}\n${todoItem['date']} at ${todoItem['time']}',
        style: TextStyle(
          decoration: todoItem['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          todoItem['completed'] ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: () => _toggleCompletion(index),
      ),
      onTap: () => _promptRemoveTodoItem(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
      ),
      body: Column(
        children: <Widget>[
          _buildInputFields(),
          Expanded(
            child: _buildTodoList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodoItem(
          _taskController.text,
          _descriptionController.text,
          _dateController.text,
          _timeController.text,
        ),
        tooltip: 'Adicionar tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Digite uma nova tarefa',
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Digite uma descrição',
            ),
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              hintText: 'Digite a data (DD/MM/YYYY)',
            ),
          ),
          TextField(
            controller: _timeController,
            decoration: const InputDecoration(
              hintText: 'Digite o horário (HH:MM)',
            ),
          ),
          IconButton(
            onPressed: () => _addTodoItem(
              _taskController.text,
              _descriptionController.text,
              _dateController.text,
              _timeController.text,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
