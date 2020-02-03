import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import 'package:simple_todo_list/model/todo_model.dart';
import 'package:simple_todo_list/helper/database.dart';

class TodoService {
  DatabaseHelper databaseHelper = DatabaseHelper();

  String todoTable = 'todo_table';

  String id = 'id';
  String title = 'title';
  String desc = 'description';
  String status = 'status';
  String date = 'date';

  TodoService() {
    debugPrint('TodoService construct...');
  }

  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.databaseHelper.database;

    return await db.query(todoTable, orderBy: '$title ASC');
  }

  Future<int> insertTodo(TodoModel todo) async {
    Database db = await this.databaseHelper.database;
    var result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  Future<int> updateTodo(TodoModel todo) async {
    var db = await this.databaseHelper.database;
    var result = await db.update(
      todoTable,
      todo.toMap(),
      where: '$id = ?',
      whereArgs: [todo.id],
    );
    return result;
  }

  Future<int> deleteTodo(int _id) async {
    var db = await this.databaseHelper.database;

    String query = 'DELETE FROM $todoTable WHERE $id = $_id';
    int result = await db.rawDelete(query);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.databaseHelper.database;

    String query = 'SELECT COUNT (*) from $todoTable';

    List<Map<String, dynamic>> x = await db.rawQuery(query);
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<TodoModel>> getTodoList() async {
    // Get 'Map List' from database
    var todoMapList = await getTodoMapList();

    // Count the number of map entries in db table
    int count = todoMapList.length;

    List<TodoModel> todoList = List<TodoModel>();
    // For loop to create a 'todoList' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(TodoModel.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }
}
