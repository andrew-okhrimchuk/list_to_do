import 'package:flutter/material.dart';
import 'data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _todoItems = [];
  final TextEditingController _textController = TextEditingController();
  int indexEdit = -1;

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      setState(() {
        if(indexEdit == -1) {
          _todoItems.add({'task': task, 'completed': false});
          _saveData();
        }
        else{
          _todoItems[indexEdit]['task'] = task;
          _saveData();
          indexEdit = -1;
        }
      });
      _textController.clear();
    }
  }

  void _toggleCompletion(int index) {
    setState(() {
      _todoItems[index]['completed'] = !_todoItems[index]['completed'];
    });
  }

  void _removeTodoItem(int index, BuildContext context) {
    showConfirmDialog(
        context,
        'Подтверждение',
        'Вы уверены, что хотите удалить?',
        'Да',
        'Нет',
            () {
          // Действие при подтверждении
              setState(() {

                _todoItems.removeAt(index);
              });
        }
    );
  }

  void _editTodoItem(int index) {
    setState(() {
      _textController.text = _todoItems[index]['task'];
      indexEdit = index;
    });
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              onSubmitted: _addTodoItem,
              decoration: const InputDecoration(
                labelText: 'Enter a task',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: Checkbox(
                      value: _todoItems[index]['completed'],
                      onChanged: (bool? value) {
                        _toggleCompletion(index);
                      },
                    ),
                    title: Text(
                      _todoItems[index]['task'],
                      style: TextStyle(
                        decoration: _todoItems[index]['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTodoItem(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeTodoItem(index, context),
                      ),
                    ]));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodoItem(_textController.text),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> showAlertDialog() async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        // returnValue = false;
       // Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed: () {
        // returnValue = true;
       // Navigator.of(context).pop(true);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return result ?? false;
  }
/////

  void showConfirmDialog(
      BuildContext context,
      String title,
      String description,
      String confirmBtnTxt,
      String cancelBtnTxt,
      Function onConfirmClicked,
      ) {
    // создаем кнопки
    Widget cancelButton = TextButton(
      child: Text(cancelBtnTxt),
      onPressed: () {
        Navigator.of(context).pop(); // закрыть диалог
      },
    );
    Widget confirmButton = TextButton(
      child: Text(confirmBtnTxt),
      onPressed: () {
        onConfirmClicked.call();
        Navigator.of(context).pop(); // закрыть диалог
      },
    );

    // создаем AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    // показываем диалог
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _saveData() async {
    await SharedPreferencesHelper.saveToDoList(_todoItems);
  }

  Future<void> _removeItem(String key) async {
    await SharedPreferencesHelper.removeItem(key);
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>>? list = await SharedPreferencesHelper.getToDoList();
    print(list);
    setState(() {
      if(list != null) {
        for (Map<String, dynamic> item in list) {
          _todoItems.add(item);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    print('_todoItems = ${_todoItems.join(', ')}');
  }
}
