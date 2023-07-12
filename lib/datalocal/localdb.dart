import 'package:hive_flutter/hive_flutter.dart';

class ToDoDB {
  var _box = Hive.box('todo');

  List toDoList = [];

  void addTask(List task) {
    toDoList.add(task);
    updateList();
  }

  void loadList() {
    toDoList = _box.get('TODOLIST');
  }

  void updateList() {
    _box.put('TODOLIST', toDoList);
  }

  int getTotalTasks() {
    return toDoList.length;
  }

  int getCompletedTasks() {
    int count = 0;
    for (var task in toDoList) {
      if (task[2] == true) {
        count++;
      }
    }
    return count;
  }
}
