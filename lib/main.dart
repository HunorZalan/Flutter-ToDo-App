import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoList(),
    );
  }
}

class Todo {
  String task;
  DateTime date;

  Todo({
    required this.task,
    required this.date,
  });
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();

  void _addTodoItem(String task) {
    setState(() {
      _todos.add(Todo(task: task, date: DateTime.now()));
    });
    _textController.clear();
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _editTodoItem(int index, String newTask) {
    setState(() {
      _todos[index].task = newTask;
    });
  }

  Widget _buildTodoItem(Todo todo, int index) {
    return ListTile(
      title: Text('${todo.task} - ${todo.date.toLocal()}'.split(' ')[0]),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _removeTodoItem(index),
      ),
      onTap: () => _showEditDialog(index),
    );
  }

  void _showEditDialog(int index) {
    _textController.text = _todos[index].task;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editTodoItem(index, _textController.text);
                _textController.clear();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Add a new task',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _addTodoItem,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(_todos[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_textController.text.isNotEmpty) {
            _addTodoItem(_textController.text);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
