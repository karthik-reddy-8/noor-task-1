import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/utilities.dart';
import 'package:flutter_todo_app/view_models/dashboard_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
      body: ModalProgressHUD(
        inAsyncCall: widget.model.isLoading,
        child: SingleChildScrollView(
          child: buildColumn(),
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
                vertical: App.height * 0.02,
                horizontal: App.width * 0.075
              ),
              child: Text(
                strings.projects,
                style: const TextStyle(fontSize: 16),
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
                    callback: (){

                    }
                ),
                buildSizedBox(
                    avatarColor: customColor.lightGreen,
                    image: 'assets/images/ic_work.png',
                    imageColor: customColor.green,
                    projectName: strings.work,
                    numberOfTasks: strings.personalTasks,
                    height: App.height * 0.04,
                    width: App.width * 0.07,
                    callback: (){

                    }
                )
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
                    callback: (){

                    }
                ),
                buildSizedBox(
                    avatarColor: customColor.lightOrange,
                    image: 'assets/images/ic_shopping.png',
                    imageColor: customColor.orange,
                    projectName: strings.shopping,
                    numberOfTasks: strings.personalTasks,
                    height: App.height * 0.06,
                    width: App.width * 0.12,
                    callback: (){

                    }
                )
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
            left: App.width * 0.01,
            right: App.width * 0.001,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello ${widget.model.userList[0].name?.substring(0, 4)}',
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
                SizedBox(
                  width: App.width * 0.38,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: customColor.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      widget.model.userList[0].photoUrl ?? '',
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
                child: Expanded(
                  flex: 2,
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
              ))
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
