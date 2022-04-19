import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/utils/app.dart';
import 'package:flutter_todo_app/utils/utilities.dart';

void showSnack(String message) {
  ScaffoldMessenger.of(App.ctx!).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.black,
    ),
  );
}

Widget elevatedButton(
    {required String message,
    required VoidCallback? callBack,
    bool isFullWidth = true,
    Color? backgroundColor}) {
  return Container(
    width: isFullWidth ? App.width : App.width * 0.6,
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [customColor.blueAccent, customColor.white],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft)),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          // primary: backgroundColor ?? customColor.blue,
          ),
      onPressed: callBack,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: App.height * 0.018),
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    ),
  );
}

Widget taskButton({
  required String message,
  required VoidCallback? callBack,
  Color? backgroundColor,
  Color? textColor,
  Color? iconColor,
  bool isBold = false,
  bool isVisible = true,
  double? fontSize,
  bool showElevation = true,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      primary: backgroundColor ?? customColor.white,
      elevation: showElevation ? 2 : 0,
    ),
    onPressed: callBack,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: App.height * 0.011),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isVisible)
            Container(
              height: App.width * 0.03,
              width: App.width * 0.03,
              decoration: BoxDecoration(
                color: iconColor ?? customColor.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          App.rowSpacer(width: App.width * 0.02),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? App.textTheme.headline6!.fontSize,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget formFieldLabel({required String label}) {
  return Text(
    label,
    textAlign: TextAlign.start,
    style: TextStyle(
        fontSize: App.textTheme.subtitle2!.fontSize,
        color: customColor.labelColor),
  );
}

Future<DateTime?> showDateTimePickerWidget(BuildContext context) async {
  final DateTime? picked = await DatePicker.showDateTimePicker(context,
      showTitleActions: true,
      minTime: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - 3, 00, 00),
      maxTime: DateTime(2030, 12, 31, 12, 59), onChanged: (date) {
    printLog(
        'change $date in time zone ' + date.timeZoneOffset.inHours.toString());
    return date;
  }, onConfirm: (date) {
    printLog('confirm $date');
    return date;
  }, locale: LocaleType.en);
  if (picked != null) {
    return picked;
  } else {
    return null;
  }
}

Widget buildCard(
    {required String title,
    required bool status,
    required VoidCallback callback}) {
  return Card(
    shadowColor: customColor.blueAccent,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      onTap: callback,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            color: customColor.labelColor,
            fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.circle,
        color: status ? customColor.greenLight : customColor.red,
      ),
      dense: true,
    ),
  );
}

Widget roundedIcon(bool isEnable) {
  return SizedBox(
    child: Container(
      height: App.width * 0.05,
      width: App.width * 0.05,
      decoration: BoxDecoration(
        color: isEnable ? customColor.blueAccent : customColor.green,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
    ),
  );
}

Widget buildBottomSheet({
  required String title,
  required BuildContext context,
  required VoidCallback cameraCallback,
  required VoidCallback galleryCallback,
}) {
  return Container(
    height: 100.0,
    width: App.width,
    margin: const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 20.0,
    ),
    child: Column(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ignore: deprecated_member_use
            FlatButton.icon(
              icon: const Icon(
                Icons.camera,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
                cameraCallback();
                // takePhoto(ImageSource.camera, context);
              },
              label: Text(strings.camera),
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
              icon: const Icon(
                Icons.image,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
                galleryCallback();
                // takePhoto(ImageSource.gallery, context);
              },
              label: Text(strings.gallery),
            )
          ],
        )
      ],
    ),
  );
}

Widget imageProfile({
  required String imageLink,
  required VoidCallback cameraCallback,
  required VoidCallback galleryCallback,
  required BuildContext context,
}) {
  printLog('result : $imageLink');
  return Stack(
    children: [
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
        elevation: 5,
        shadowColor: customColor.white,
        child: CircleAvatar(
          radius: 70,
          backgroundColor: customColor.white,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(70),
            child: Image.network(
              imageLink.toString(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                        color: customColor.blueAccent));
              },
              alignment: Alignment.center,
              height: App.width * 0.34,
              width: App.width * 0.34,
              errorBuilder: (context, object, stackTrace) {
                return const Icon(Icons.person);
              },
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 4.0,
        right: 3.0,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: ((builder) => buildBottomSheet(
                  cameraCallback: () => cameraCallback(),
                  context: context,
                  title: strings.choosePhoto,
                  galleryCallback: () => galleryCallback())),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.teal,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
      )
    ],
  );
}
