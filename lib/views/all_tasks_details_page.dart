import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/database/entity/task.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/progress_dialog.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/view_models/all_task_details_view_model.dart';
import 'package:stacked/stacked.dart';

class AllTasksDetailsPage extends StatefulWidget {
  const AllTasksDetailsPage(
      {Key? key, required this.model, required this.workType})
      : super(key: key);
  final AllTaskDetailsViewModel model;
  final String workType;

  @override
  State<AllTasksDetailsPage> createState() => _AllTasksDetailsPageState();
}

class _AllTasksDetailsPageState extends State<AllTasksDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressDialog(
        inAsyncCall: widget.model.isLoading,
        child: FutureBuilder(
          future: widget.model.getAllTodos(widget.workType),
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
                      await widget.model.database?.todoDAO
                          .deleteTodo(snapshot.data![index].id!);
                      setState(() async {
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
                          showSnack(strings.updatedSuccessfully);
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

class AllTasksDetails extends StatelessWidget {
  const AllTasksDetails({Key? key, required this.workType}) : super(key: key);
  final String workType;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllTaskDetailsViewModel>.reactive(
        viewModelBuilder: () => AllTaskDetailsViewModel(),
        builder: (_, model, __) {
          return AllTasksDetailsPage(
            model: model,
            workType: workType,
          );
        });
  }
}
