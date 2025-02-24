import 'dart:convert';

import 'package:Todquest_task/model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  @override
  void onInit() {
    loadTasks();
    super.onInit();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List<dynamic> jsonData = jsonDecode(tasksString);
      tasks.assignAll(jsonData.map((task) => Task.fromJson(task)).toList());
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString =
        jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksString);
  }

  void addTask(String title) {
    var task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(), title: title);
    tasks.add(task);
    saveTasks();
  }

  void toggleTask(String id) {
    var taskIndex = tasks.indexWhere((task) => task.id == id);
    tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
    tasks.refresh();
    saveTasks();
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    saveTasks();
  }
}
