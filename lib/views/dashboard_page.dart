import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/enums/work_type.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/progress_dialog.dart';
import 'package:flutter_todo_app/utils/text_form_filed.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/view_models/dashboard_view_model.dart';
import 'package:flutter_todo_app/views/task_details_page.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({
    Key? key,
    required this.model,
    required this.userName,
    required this.userProfilePic,
  }) : super(key: key);
  final DashboardViewModel model;
  final String userName;
  final String userProfilePic;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String time = '';
  int todayTodosCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    time = Jiffy().jm;
    _timer = Timer.periodic(const Duration(minutes: 1), (t) {
      widget.model.getAll(time);
      printLog('time is $time');
      setState(() {
        time = Jiffy().jm;
        widget.model.todayTodosCount = widget.model.todayTodosCount;
      });
    });
    widget.model.getDataFromPrefs();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
  }

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
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
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
                numberOfTasks: "${widget.model.personalTodosCount} Tasks",
                height: App.height * 0.04,
                width: App.width * 0.08,
                callback: () {
                  App.push(TasksDetails(workType: strings.personal));
                }),
            buildSizedBox(
                avatarColor: customColor.lightGreen,
                image: 'assets/images/ic_work.png',
                imageColor: customColor.green,
                projectName: strings.work,
                numberOfTasks: '${widget.model.workTodosCount} Tasks',
                height: App.height * 0.04,
                width: App.width * 0.07,
                callback: () {
                  App.push(TasksDetails(workType: strings.work));
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
                numberOfTasks: '${widget.model.meetingTodosCount} Tasks',
                height: App.height * 0.04,
                width: App.width * 0.08,
                callback: () {
                  App.push(TasksDetails(workType: strings.meeting));
                }),
            buildSizedBox(
                avatarColor: customColor.lightOrange,
                image: 'assets/images/ic_shopping.png',
                imageColor: customColor.orange,
                projectName: strings.shopping,
                numberOfTasks: '${widget.model.shoppingTodosCount} Tasks',
                height: App.height * 0.06,
                width: App.width * 0.12,
                callback: () {
                  App.push(TasksDetails(workType: strings.shopping));
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.name.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: customColor.white),
                    ),
                    Text(
                      'Today you have ${widget.model.todayTodosCount} tasks',
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
                      widget.model.navigateUserPage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        widget.model.imageUrl.toString(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                color: customColor.blueAccent),
                          );
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
            ),
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
                      if (widget.model.todayTodoTitle.toString() != 'null')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.model.todayTodoTitle.toString(),
                              style: TextStyle(color: customColor.white),
                            ),
                            App.columnSpacer(height: App.height * 0.01),
                            Text(
                              widget.model.todayTodoTime.toString(),
                              style: TextStyle(color: customColor.white),
                            ),
                          ],
                        ),
                      App.columnSpacer(height: App.height * 0.01),
                      if (widget.model.todayTodoTitle.toString() == 'null')
                        Text(
                          'No data found',
                          style: TextStyle(color: customColor.white),
                        ),
                      App.columnSpacer(),
                    ],
                  ),
                  App.rowSpacer(width: App.width * 0.25),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/ic_bell.png',
                          height: App.height * 0.16,
                          width: App.width * 0.17,
                        )
                      ],
                    ),
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
  const DashboardPage(
      {Key? key, required this.userName, required this.userProfilePic})
      : super(key: key);
  final String userName;
  final String userProfilePic;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => DashboardViewModel(),
        onModelReady: (m) => m.initCall(),
        builder: (_, model, __) {
          return DashBoard(
            model: model,
            userProfilePic: userProfilePic,
            userName: userName,
          );
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
  WorkType currentWorkType = WorkType.personal;
  String todoCreatedDateTime = DateTime.now().toString();

  changeWorkStatus(WorkType workType) async {
    setState(() {
      currentWorkType = workType;
    });
  }

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
                App.pop();
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
                      changeWorkStatus(WorkType.personal);
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
                      changeWorkStatus(WorkType.work);
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
                      changeWorkStatus(WorkType.meeting);
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
                      changeWorkStatus(WorkType.shopping);
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
              Expanded(
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                  icon: const Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Time",
                  selectableDayPredicate: (date) {
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }
                    return true;
                  },
                  onChanged: (val) {
                    printLog('selected date: $val');
                    widget.model.saveDateTime(val);
                  },
                  validator: (val) {
                    printLog(val);
                    return null;
                  },
                  onSaved: (val) => printLog('date: $val'),
                ),
              ),
            ],
          ),
          App.columnSpacer(height: App.height * 0.01),
          elevatedButton(
            message: strings.addTask,
            callBack: () {
              if (widget.model.formKey.currentState!.validate()) {
                widget.model.addTodoItem();
                widget.model.getAllTodosByType();
                App.pop();
              }
            },
            backgroundColor: customColor.blueAccent,
          ),
        ],
      ),
    );
  }
}
