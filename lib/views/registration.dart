import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/text_form_filed.dart';
import 'package:flutter_todo_app/view_models/registration_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key, required this.model}) : super(key: key);
  final RegistrationViewModel model;
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(strings.registration),
        iconTheme: IconThemeData(
          color: customColor.white,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: widget.model.isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: buildContainer(widget.model),
          ),
        ),
      ),
    );
  }

  Container buildContainer(RegistrationViewModel model) {
    return Container(
      width: 400,
      padding: EdgeInsets.symmetric(
          vertical: App.height * 0.01, horizontal: App.width * 0.1),
      child: Form(
        key: model.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            App.columnSpacer(),
            Center(
              child: model.imageProfile(context,model.photoLink),
            ),
            App.columnSpacer(),
            formFieldLabel(label: strings.firstName),
            App.columnSpacer(height: App.height * 0.01),
            TextFormFieldWidget(
              controller: model.firstName,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.text,
              inputAction: TextInputAction.next,
              isEnabled: true,
              hasBorder: true,
              formatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    r'[a-zA-Z ]',
                  ),
                ),
              ],
            ),
            App.columnSpacer(),
            formFieldLabel(label: strings.lastName),
            App.columnSpacer(height: App.height * 0.01),
            TextFormFieldWidget(
              controller: model.lastName,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.text,
              inputAction: TextInputAction.next,
              isEnabled: true,
              hasBorder: true,
              formatter: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    r'[a-zA-Z ]',
                  ),
                ),
              ],
            ),
            App.columnSpacer(),
            formFieldLabel(label: strings.phone),
            App.columnSpacer(height: App.height * 0.01),
            TextFormFieldWidget(
              controller: model.contactNumber,
              validationType: Validations.mobile,
              inputType: TextInputType.number,
              inputAction: TextInputAction.next,
              isEnabled: true,
              hasBorder: true,
              formatter: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            App.columnSpacer(),
            formFieldLabel(label: strings.email),
            App.columnSpacer(height: App.height * 0.01),
            TextFormFieldWidget(
              controller: model.email,
              validationType: Validations.requiredFieldValidator,
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.next,
              isEnabled: true,
              hasBorder: true,
            ),
            App.columnSpacer(),
            formFieldLabel(label: strings.password),
            App.columnSpacer(height: App.height * 0.01),
            TextFormFieldWidget(
              controller: model.password,
              hasBorder: true,
              obscure: model.secureText,
              isEnabled: true,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              validationType: Validations.requiredFieldValidator,
              // formatter: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp(
              //       r'[a-zA-Z][0-9]',
              //     ),
              //   ),
              // ],
              suffixIcon: IconButton(
                icon: Icon(
                  model.secureText
                      ? Icons.visibility_off
                      : Icons.remove_red_eye,
                ),
                onPressed: () {
                  setState(() {
                    model.secureText = !model.secureText;
                  });
                },
              ),
            ),
            App.columnSpacer(),
            elevatedButton(
                message: strings.register,
                backgroundColor: customColor.blueAccent,
                callBack: () {
                  if (model.formKey.currentState!.validate()) {
                    model.registerToFb(context);
                  }
                }),
            App.columnSpacer(),
          ],
        ),
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
        viewModelBuilder: () => RegistrationViewModel(),
        builder: (_, model, __) {
          return Registration(
            model: model,
          );
        });
  }
}
