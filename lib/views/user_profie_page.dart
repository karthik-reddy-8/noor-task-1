import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/progress_dialog.dart';
import 'package:flutter_todo_app/utils/text_form_filed.dart';
import 'package:flutter_todo_app/view_models/user_profile_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.model}) : super(key: key);
  final UserProfileViewModel model;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.userProfile),
      ),
      body: ProgressDialog(
        inAsyncCall: widget.model.isLoading,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom
          ),
          child: buildContainer(context, widget.model),
        ),
      ),
    );
  }

  Container buildContainer(BuildContext context, UserProfileViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: App.height * 0.01, horizontal: App.width * 0.1),
      child: Form(
        key: model.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            App.columnSpacer(),
            imageProfile(
                imageLink: model.profileImage.toString(),
                cameraCallback: () {
                  model.takePhoto(ImageSource.camera, context);
                },
                galleryCallback: () {
                  model.takePhoto(ImageSource.gallery, context);
                },
                context: context),
            App.columnSpacer(height: App.height * 0.07),
            TextFormFieldWidget(
              hint: strings.name,
              controller: model.nameController,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.none,
              inputAction: TextInputAction.done,
              isEnabled: true,
              prefixIcon: const Icon(Icons.person),
              suffixIcon: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: UpdateUserDetails(
                            controller: model.nameController,
                            title: strings.name,
                            model: model,
                            keyPair: 'name',
                            value: model.nameController.text,
                          )));
                },
                icon: Icon(
                  Icons.edit,
                  color: customColor.swatchColor,
                ),
              ),
            ),
            App.columnSpacer(height: App.height * 0.05),
            TextFormFieldWidget(
              hint: strings.email,
              controller: model.emailController,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.none,
              inputAction: TextInputAction.done,
              isEnabled: true,
              prefixIcon: const Icon(Icons.error_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      builder: (context) => SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: UpdateUserDetails(
                            controller: model.emailController,
                            title: strings.email,
                            model: model,
                            keyPair: 'email',
                            value: model.emailController.text,
                          )));
                },
                icon: Icon(
                  Icons.edit,
                  color: customColor.swatchColor,
                ),
              ),
            ),
            App.columnSpacer(height: App.height * 0.05),
            TextFormFieldWidget(
              hint: strings.phone,
              controller: model.contactNumberController,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.none,
              inputAction: TextInputAction.done,
              isEnabled: true,
              prefixIcon: const Icon(Icons.phone),
              formatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    r'[a-zA-Z ]',
                  ),
                ),
              ],
            ),
            App.columnSpacer(height: App.height * 0.05),
            elevatedButton(
                message: strings.logOut,
                backgroundColor: customColor.blueAccent,
                callBack: () {
                  model.userSignOut(context);
                }),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
        viewModelBuilder: () => UserProfileViewModel(),
        onModelReady: (m) => m.initCall(),
        builder: (_, model, __) {
          return UserProfile(model: model);
        });
  }
}

class UpdateUserDetails extends StatefulWidget {
  const UpdateUserDetails(
      {Key? key,
      required this.title,
      required this.controller,
      required this.model,
      required this.keyPair,
      required this.value})
      : super(key: key);
  final String title;
  final TextEditingController controller;
  final String keyPair;
  final String value;
  final UserProfileViewModel model;

  @override
  _UpdateUserDetailsState createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: customColor.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter your ${widget.title}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            App.columnSpacer(height: App.height * 0.02),
            TextFormFieldWidget(
              controller: widget.controller,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              isEnabled: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      strings.cancel,
                      style: TextStyle(color: customColor.labelColor),
                    )),
                const SizedBox(),
                TextButton(
                    onPressed: () {
                      widget.model
                          .updateDetails(widget.keyPair, widget.value);
                      Navigator.pop(context);
                    },
                    child: Text(
                      strings.save,
                      style: TextStyle(color: customColor.labelColor),
                    )),
              ],
            )
          ],
        ));
  }
}
