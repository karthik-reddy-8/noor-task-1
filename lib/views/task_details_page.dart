import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/progress_dialog.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/view_models/tasks_detils_view_model.dart';
import 'package:stacked/stacked.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({Key? key, required this.model}) : super(key: key);
  final TaskDetailsViewModel model;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backwardsCompatibility: true,
        centerTitle: true,
        title: Text(strings.allTasks),
        iconTheme: IconThemeData(color: customColor.white),
      ),
      body: ProgressDialog(
        child: widget.model.tabs[widget.model.selectedIndex],
        inAsyncCall: widget.model.isLoading,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: customColor.white.withOpacity(0.8),
        selectedItemColor: customColor.white,
        currentIndex: widget.model.selectedIndex,
        onTap: (index) => setState(() {
          widget.model.selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task,
              color: customColor.white,
            ),
            label: strings.allTasks,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_task_outlined,
              color: customColor.white,
              size: 28,
            ),
            label: strings.onGoingTasks,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task_sharp,
              color: customColor.white,
              size: 28,
            ),
            label: strings.completedTasks,
          ),
        ],
      ),
    );
  }
}

class TasksDetails extends StatelessWidget {
  const TasksDetails({Key? key, required this.workType}) : super(key: key);
  final String workType;

  @override
  Widget build(BuildContext context) {
    printLog(workType);
    return ViewModelBuilder<TaskDetailsViewModel>.reactive(
        viewModelBuilder: () => TaskDetailsViewModel(),
        onModelReady: (m) => m.initCAll(workType),
        builder: (_, model, __){
          return TaskDetailsPage(model: model);
        });
  }
}

