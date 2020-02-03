import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simple_todo_list/model/todo_model.dart';
import 'package:simple_todo_list/view/todo_edit.dart';
import 'package:simple_todo_list/service/todo_service.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  bool _isSnackbarActive = false;

  TodoService service = TodoService();

  List<TodoModel> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<TodoModel>();
      fetchToView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo List App',
          style: TextStyle(color: Colors.white, fontFamily: 'Karla'),
        ),
        centerTitle: true,
      ),
      body: todoList.isEmpty ? emptyTodo() : getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToViewPage(TodoModel('', 0, ''), 'New Todo');
        },
        tooltip: 'New Todo',
        child: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Colors.brown,
      ),
    );
  }

  Container emptyTodo() {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Text("No todos yet...", style: TextStyle(fontSize: 25)),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              child: Checkbox(
                value: this.todoList[position].statusBool,
                onChanged: (value) {
                  setState(() {
                    this.todoList[position].statusBool = value;
                    _updateStatus(context, todoList[position]);
                  });
                },
              ),
            ),
            title: Text(
              this.todoList[position].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Karla',
                decoration: this.todoList[position].status != 0
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                this.todoList[position].description,
                maxLines: 3,
                style: TextStyle(
                  decoration: this.todoList[position].status != 0
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.close, color: Colors.red, size: 30),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateToViewPage(this.todoList[position], 'Update Todo');
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, TodoModel todo) async {
    int result = await service.deleteTodo(todo.id);
    if (result != 0) {
      if (!_isSnackbarActive) _showToast(context, 'Todo deleted successfully');

      fetchToView();
    }
  }

  void _updateStatus(BuildContext context, TodoModel todo) async {
    int result = await service.updateTodo(todo);
    if (result != 0) {
      String resultMsg = 'Marked as pending...';
      if (todo.status == 1) {
        resultMsg = 'Marked as done...';
      }
      if (!_isSnackbarActive) _showToast(context, resultMsg);
    }
  }

  void _showToast(BuildContext context, String message) {
    _isSnackbarActive = true;

    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
      ),
    );
    Scaffold.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((SnackBarClosedReason reason) {
      _isSnackbarActive = false;
    });
  }

  void navigateToViewPage(TodoModel todo, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ViewPage(todo, title);
      },
    ));

    if (result == true) {
      fetchToView();
    }
  }

  void fetchToView() {
    Future<List<TodoModel>> todoListFuture = service.getTodoList();
    todoListFuture.then((todoList) {
      setState(() {
        this.todoList = todoList;
        this.count = todoList.length;
      });
    });
  }
}
