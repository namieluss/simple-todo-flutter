import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:simple_todo_list/model/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/service/todo_service.dart';

class ViewPage extends StatefulWidget {
  final String appBarTitle;
  final TodoModel todo;

  ViewPage(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ViewPageState(this.todo, this.appBarTitle);
  }
}

class ViewPageState extends State<ViewPage> {
  TodoService service = TodoService();

  String appBarTitle;
  TodoModel todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ViewPageState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitle,
              style: TextStyle(color: Colors.white, fontFamily: 'Karla'),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
              color: Colors.white,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      todo.title = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: "Enter title here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value) {
                      todo.description = value;
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Description',
                      // labelStyle: textStyle,
                      hintText: "Enter description here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    maxLines: 5,
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('Save', textScaleFactor: 1.5),
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      todo.id != null
                          ? Expanded(
                              child: RaisedButton(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                color: Colors.redAccent,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text('Delete', textScaleFactor: 1.5),
                                onPressed: () {
                                  setState(() {
                                    _delete();
                                  });
                                },
                              ),
                            )
                          : Container(width: 0.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    /**
     * create new todoItem if todoId is null
     */
    int result = todo.id != null
        ? await service.updateTodo(todo)
        : await service.insertTodo(todo);

    String resultMsg = 'Todo saved successfully...';
    if (result == 0) resultMsg = 'Oops, problem with saving todo...';

    _showAlertDialog('Status', resultMsg);
  }

  void _delete() async {
    moveToLastScreen();

    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    /**
     * Case 2: User is trying to delete the old todo that already has a valid ID.
     */
    int result = await service.deleteTodo(todo.id);

    String resultMsg = 'Todo deleted successfully...';
    if (result == 0) resultMsg = 'Oops, error occured while deleting todo';

    _showAlertDialog('Status', resultMsg);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
