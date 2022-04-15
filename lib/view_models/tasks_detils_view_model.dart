import 'package:flutter/material.dart';
import 'package:flutter_todo_app/views/all_tasks_details_page.dart';
import 'package:flutter_todo_app/views/completed_task_page.dart';
import 'package:flutter_todo_app/views/onGoing_tasks_page.dart';


class TaskDetailsViewModel extends ChangeNotifier{
  int selectedIndex = 0;
  bool isLoading = false;

  final tabs = [];

  Future<void> initCAll(String workType) async{
    tabs.add(AllTasksDetails(workType: workType));
    tabs.add(OngoingTasks(workType: workType));
    tabs.add(CompletedTasks(workType: workType,));
    notifyListeners();
  }

}