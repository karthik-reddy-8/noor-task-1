import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/enums/work_type.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/progress_dialog.dart';
import 'package:flutter_todo_app/utils/text_form_filed.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/view_models/dashboard_view_model.dart';
import 'package:flutter_todo_app/views/task_details_page.dart';
import 'package:flutter_todo_app/views/user_profie_page.dart';
import 'package:stacked/stacked.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final DashboardViewModel model;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ProgressDialog(
        inAsyncCall: widget.model.isLoading,
        child: SingleChildScrollView(
          child: buildColumn(),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
            vertical: App.height * 0.008, horizontal: App.width * 0.015),
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: customColor.white,
          ),
          backgroundColor: customColor.blueAccent,
          onPressed: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.elliptical(70, 70))),
              isScrollControlled: true,
              context: context,
              builder: ((builder) => SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: BottomSheet(
                  model: widget.model,
                ),
              )),
            );
          },
        ),
      ),
    );
  }

  Container bottomSheet(BuildContext context, DashboardViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: App.width * 0.05),
      height: App.height * 0.3,
      width: App.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 8,
            color: customColor.pink,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            shadowColor: customColor.pink,
            child: IconButton(
              iconSize: 50,
              icon: Icon(
                Icons.clear,
                color: customColor.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          App.columnSpacer(height: App.height * 0.02),
          Text(
            strings.addNewTask,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: customColor.labelColor),
          ),
          App.columnSpacer(height: App.height * 0.02),
          TextFormFieldWidget(
            controller: model.taskController,
            hint: strings.addYourTask,
            validationType: Validations.requiredFieldValidator,
            inputType: TextInputType.text,
            inputAction: TextInputAction.next,
            isLabelFloating: false,
            needSpace: false,
            maxLengthEnforced: true,
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                App.columnSpacer(height: App.height * 0.02),
                taskButton(
                    message: strings.personal,
                    fontSize: App.textTheme.caption!.fontSize,
                    iconColor: widget.model.currentWorkType != WorkType.personal
                        ? customColor.yellow
                        : null,
                    backgroundColor:
                        widget.model.currentWorkType == WorkType.personal
                            ? customColor.yellow
                            : null,
                    textColor: widget.model.currentWorkType == WorkType.personal
                        ? null
                        : customColor.labelColor,
                    isVisible: widget.model.currentWorkType != WorkType.personal
                        ? true
                        : false,
                    callBack: () {
                      widget.model.changeWorkStatus(WorkType.personal);
                    }),
                App.rowSpacer(width: App.width * 0.03),
                taskButton(
                    message: strings.work,
                    fontSize: App.textTheme.caption!.fontSize,
                    iconColor: widget.model.currentWorkType != WorkType.work
                        ? customColor.green
                        : null,
                    backgroundColor:
                        widget.model.currentWorkType == WorkType.work
                            ? customColor.green
                            : null,
                    textColor: widget.model.currentWorkType == WorkType.work
                        ? null
                        : customColor.labelColor,
                    isVisible: widget.model.currentWorkType != WorkType.work
                        ? true
                        : false,
                    callBack: () {
                      widget.model.changeWorkStatus(WorkType.work);
                    }),
                App.rowSpacer(width: App.width * 0.03),
                taskButton(
                    message: strings.meeting,
                    fontSize: App.textTheme.caption!.fontSize,
                    iconColor: widget.model.currentWorkType != WorkType.meeting
                        ? customColor.pink
                        : null,
                    backgroundColor:
                        widget.model.currentWorkType == WorkType.meeting
                            ? customColor.pink
                            : null,
                    textColor: widget.model.currentWorkType == WorkType.meeting
                        ? null
                        : customColor.labelColor,
                    isVisible: widget.model.currentWorkType != WorkType.meeting
                        ? true
                        : false,
                    callBack: () {
                      widget.model.changeWorkStatus(WorkType.meeting);
                    }),
                App.rowSpacer(width: App.width * 0.03),
                taskButton(
                    message: strings.shopping,
                    fontSize: App.textTheme.caption!.fontSize,
                    iconColor: widget.model.currentWorkType != WorkType.shopping
                        ? customColor.orange
                        : null,
                    backgroundColor:
                        widget.model.currentWorkType == WorkType.shopping
                            ? customColor.orange
                            : null,
                    textColor: widget.model.currentWorkType == WorkType.shopping
                        ? null
                        : customColor.labelColor,
                    isVisible: widget.model.currentWorkType != WorkType.shopping
                        ? true
                        : false,
                    callBack: () {
                      widget.model.changeWorkStatus(WorkType.shopping);
                    }),
              ],
            ),
          ),
          App.columnSpacer(height: App.height * 0.01),
          Divider(
            height: App.height * 0.003,
            thickness: App.height * 0.001,
            color: customColor.labelColor,
          ),
          App.columnSpacer(height: App.height * 0.1),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              strings.chooseDate,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: customColor.labelColor),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.model.selectedDateTime.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              App.rowSpacer(width: App.width * 0.01),
              Text(
                widget.model.selectedTime.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: customColor.black,
                  size: 20,
                ),
                onPressed: () {
                  widget.model.setDateTime(context);
                },
              )
            ],
          ),
          App.columnSpacer(height: App.height * 0.05),
          elevatedButton(
            message: strings.addTask,
            callBack: () {
              widget.model.addTodo();
              Navigator.pop(context);
            },
            backgroundColor: customColor.blueAccent,
          ),
        ],
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: App.height * 0.01, horizontal: App.width * 0.075),
          child: Text(
            strings.projects,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSizedBox(
                avatarColor: customColor.lightYellow,
                image: 'assets/images/ic_user.png',
                imageColor: customColor.yellow,
                projectName: strings.personal,
                numberOfTasks: strings.personalTasks,
                height: App.height * 0.04,
                width: App.width * 0.08,
                callback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TasksDetails(workType: strings.personal)));
                }),
            buildSizedBox(
                avatarColor: customColor.lightGreen,
                image: 'assets/images/ic_work.png',
                imageColor: customColor.green,
                projectName: strings.work,
                numberOfTasks: strings.personalTasks,
                height: App.height * 0.04,
                width: App.width * 0.07,
                callback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TasksDetails(workType: strings.work)));
                })
          ],
        ),
        App.columnSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSizedBox(
                avatarColor: customColor.lightPink,
                image: 'assets/images/ic_meeting.png',
                imageColor: customColor.pink,
                projectName: strings.meeting,
                numberOfTasks: strings.personalTasks,
                height: App.height * 0.04,
                width: App.width * 0.08,
                callback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TasksDetails(workType: strings.meeting)));
                }),
            buildSizedBox(
                avatarColor: customColor.lightOrange,
                image: 'assets/images/ic_shopping.png',
                imageColor: customColor.orange,
                projectName: strings.shopping,
                numberOfTasks: strings.personalTasks,
                height: App.height * 0.06,
                width: App.width * 0.12,
                callback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TasksDetails(workType: strings.shopping)));
                })
          ],
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: customColor.blueAccent,
      flexibleSpace: Container(
        width: App.width,
        decoration: BoxDecoration(
          color: customColor.blueAccent,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Stack(fit: StackFit.expand, children: [
          Positioned(
            top: -App.width * 0.045,
            bottom: App.width * 0.48,
            right: -App.width * 0.10,
            child: Container(
              width: App.width * 0.295,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(190),
                    bottomLeft: Radius.circular(90),
                    topLeft: Radius.circular(190),
                    topRight: Radius.circular(50)),
                color: Colors.white30,
              ),
            ),
          ),
          Positioned(
            top: -App.width * 1.05,
            bottom: App.width * 0.451,
            left: -App.width * 0.20,
            child: Container(
              width: App.width * 0.55,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(90),
                    bottomLeft: Radius.circular(120)),
                color: Colors.white30,
              ),
            ),
          ),
          Positioned(
            top: App.height * 0.08,
            left: App.width * 0.05,
            right: App.width * 0.05,
            child: ViewModelBuilder<DashboardViewModel>.reactive(
                viewModelBuilder: () => DashboardViewModel(),
                onModelReady: (m) => m.getDataFromPrefs(),
                builder: (_, m, __){
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.name.toString(),
                            // widget.model.name.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: customColor.white),
                          ),
                          Text(
                            'Today you have 9 tasks',
                            style: TextStyle(color: customColor.white),
                          ),
                        ],
                      ),
                      const SizedBox(),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: customColor.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserProfilePage()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              // widget.model.imageUrl.toString(),
                              m.imageUrl.toString(),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: customColor.blueAccent));
                              },
                              alignment: Alignment.center,
                              height: App.width * 0.11,
                              width: App.width * 0.11,
                              errorBuilder: (context, object, stackTrace) {
                                return const Icon(Icons.person);
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          Positioned(
            top: App.height * 0.155,
            left: App.width * 0.04,
            right: App.width * 0.04,
            bottom: App.height * 0.019,
            child: Container(
              height: App.height * 0.1,
              width: App.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  App.rowSpacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      App.columnSpacer(height: App.height * 0.04),
                      Text(
                        strings.todayReminder,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: customColor.white),
                      ),
                      App.columnSpacer(height: App.height * 0.01),
                      Text(
                        strings.meetingWithClient,
                        style: TextStyle(color: customColor.white),
                      ),
                      App.columnSpacer(height: App.height * 0.01),
                      Text(
                        strings.time,
                        style: TextStyle(color: customColor.white),
                      ),
                      App.columnSpacer(),
                    ],
                  ),
                  App.rowSpacer(width: App.width * 0.25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/ic_bell.png',
                        height: App.height * 0.16,
                        width: App.width * 0.17,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
      toolbarHeight: App.height * 0.28,
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        onModelReady: (m) => m.initCall(),
        builder: (_, model, __) {
          return DashBoard(model: model);
        });
  }
}

class BottomSheet extends StatefulWidget {
  const BottomSheet({Key? key, required this.model}) : super(key: key);
  final DashboardViewModel model;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: App.width * 0.05),
      height: App.height * 0.55,
      width: App.width,
      transform: Matrix4.translationValues(0.0, -30, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 8,
            color: customColor.pink,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            shadowColor: customColor.pink,
            child: IconButton(
              iconSize: 50,
              icon: Icon(
                Icons.clear,
                color: customColor.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          App.columnSpacer(height: App.height * 0.02),
          Text(
            strings.addNewTask,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: customColor.labelColor),
          ),
          App.columnSpacer(height: App.height * 0.02),
          Form(
            key: widget.model.formKey,
            child: TextFormFieldWidget(
              controller: widget.model.taskController,
              hint: strings.addYourTask,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.text,
              inputAction: TextInputAction.next,
              isLabelFloating: false,
              needSpace: false,
              maxLengthEnforced: true,
            ),
          ),
          App.columnSpacer(height: App.height * 0.01),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  App.columnSpacer(height: App.height * 0.01),
                  taskButton(
                      message: strings.personal,
                      fontSize: App.textTheme.caption!.fontSize,
                      iconColor: widget.model.currentWorkType != WorkType.personal
                          ? customColor.yellow
                          : null,
                      backgroundColor:
                      widget.model.currentWorkType == WorkType.personal
                          ? customColor.yellow
                          : null,
                      textColor: widget.model.currentWorkType == WorkType.personal
                          ? null
                          : customColor.labelColor,
                      isVisible: widget.model.currentWorkType != WorkType.personal
                          ? true
                          : false,
                      callBack: () {
                        widget.model.changeWorkStatus(WorkType.personal);
                      }),
                  App.rowSpacer(width: App.width * 0.03),
                  taskButton(
                      message: strings.work,
                      fontSize: App.textTheme.caption!.fontSize,
                      iconColor: widget.model.currentWorkType != WorkType.work
                          ? customColor.green
                          : null,
                      backgroundColor:
                      widget.model.currentWorkType == WorkType.work
                          ? customColor.green
                          : null,
                      textColor: widget.model.currentWorkType == WorkType.work
                          ? null
                          : customColor.labelColor,
                      isVisible: widget.model.currentWorkType != WorkType.work
                          ? true
                          : false,
                      callBack: () {
                        widget.model.changeWorkStatus(WorkType.work);
                      }),
                  App.rowSpacer(width: App.width * 0.03),
                  taskButton(
                      message: strings.meeting,
                      fontSize: App.textTheme.caption!.fontSize,
                      iconColor: widget.model.currentWorkType != WorkType.meeting
                          ? customColor.pink
                          : null,
                      backgroundColor:
                      widget.model.currentWorkType == WorkType.meeting
                          ? customColor.pink
                          : null,
                      textColor: widget.model.currentWorkType == WorkType.meeting
                          ? null
                          : customColor.labelColor,
                      isVisible: widget.model.currentWorkType != WorkType.meeting
                          ? true
                          : false,
                      callBack: () {
                        widget.model.changeWorkStatus(WorkType.meeting);
                      }),
                  App.rowSpacer(width: App.width * 0.03),
                  taskButton(
                      message: strings.shopping,
                      fontSize: App.textTheme.caption!.fontSize,
                      iconColor: widget.model.currentWorkType != WorkType.shopping
                          ? customColor.orange
                          : null,
                      backgroundColor:
                      widget.model.currentWorkType == WorkType.shopping
                          ? customColor.orange
                          : null,
                      textColor: widget.model.currentWorkType == WorkType.shopping
                          ? null
                          : customColor.labelColor,
                      isVisible: widget.model.currentWorkType != WorkType.shopping
                          ? true
                          : false,
                      callBack: () {
                        widget.model.changeWorkStatus(WorkType.shopping);
                      }),
                ],
              ),
            ),
          App.columnSpacer(height: App.height * 0.01),
          Divider(
            height: App.height * 0.003,
            thickness: App.height * 0.001,
            color: customColor.labelColor,
          ),
          App.columnSpacer(height: App.height * 0.01),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              strings.chooseDate,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: customColor.labelColor),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.model.selectedDateTime.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              App.rowSpacer(width: App.width * 0.01),
              Text(
                widget.model.selectedTime.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: customColor.black,
                  size: 20,
                ),
                onPressed: () {
                  widget.model.setDateTime(context);
                },
              )
            ],
          ),
          App.columnSpacer(height: App.height * 0.01),
          elevatedButton(
            message: strings.addTask,
            callBack: () {
              widget.model.addTodo();
              Navigator.pop(context);
            },
            backgroundColor: customColor.blueAccent,
          ),
        ],
      ),
    );
  }
}
