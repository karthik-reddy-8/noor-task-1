import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/progress_dialog.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/view_models/ongoing_tasks_view_model.dart';
import 'package:stacked/stacked.dart';

class OngoingTasksPage extends StatefulWidget {
  const OngoingTasksPage(
      {Key? key, required this.model, required this.workType})
      : super(key: key);
  final OngoingTasksViewModel model;
  final String workType;

  @override
  State<OngoingTasksPage> createState() => _OngoingTasksPageState();
}

class _OngoingTasksPageState extends State<OngoingTasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressDialog(
        inAsyncCall: widget.model.isLoading,
        child: FutureBuilder(
          future: widget.model.getOngoingTodos(false, widget.workType),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasData) {
              printLog(snapshot.data?.length);
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding:
                          EdgeInsets.symmetric(horizontal: App.height * 0.05),
                      child: const Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id!),
                    onDismissed: (DismissDirection direction) async {
                      await widget.model.database!.todoDAO
                          .deleteTodo(snapshot.data![index].id!);
                      setState(() {
                        printLog('Type of work: ${snapshot.data![index].id!}');
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: buildCard(
                        title: snapshot.data![index].title,
                        status: snapshot.data![index].finished,
                        callback: () {
                          widget.model.updateTodo(
                              snapshot.data![index].finished,
                              snapshot.data![index].id!);
                          showSnack(strings.updatedSuccessfully, context);
                        }),
                  );
                },
              );
            } else {
              return Center(child: Text(strings.noDataFound));
            }
          },
        ),
      ),
    );
  }
}

class OngoingTasks extends StatelessWidget {
  const OngoingTasks({Key? key, required this.workType}) : super(key: key);
  final String workType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OngoingTasksViewModel>.reactive(
        viewModelBuilder: () => OngoingTasksViewModel(),
        builder: (_, model, __) {
          return OngoingTasksPage(model: model, workType: workType);
        });
  }
}
