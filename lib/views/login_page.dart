import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constraints/colors.dart';
import 'package:flutter_todo_app/constraints/strings.dart';
import 'package:flutter_todo_app/enums/validation.dart';
import 'package:flutter_todo_app/utils/App.dart';
import 'package:flutter_todo_app/utils/custom_widgets.dart';
import 'package:flutter_todo_app/utils/text_form_filed.dart';
import 'package:flutter_todo_app/view_models/login_view_model.dart';
import 'package:flutter_todo_app/views/registration.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.model}) : super(key: key);
  final LoginViewModel model;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: widget.model.isLoading,
        child: SingleChildScrollView(
          child: buildColumn(widget.model),
        ),
      ),
    );
  }

  Column buildColumn(LoginViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildContainer(),
        Center(
          child: Container(
            width: App.width * 0.9,
            padding: EdgeInsets.symmetric(
                vertical: App.height * 0.1, horizontal: App.width * 0.01),
            child: Form(
              key: model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.userLogin,
                    style: TextStyle(
                        fontSize: 18,
                        color: customColor.black,
                        fontWeight: FontWeight.w600),
                  ),
                  App.columnSpacer(),
                  formFieldLabel(label: strings.email),
                  App.columnSpacer(),
                  TextFormFieldWidget(
                    controller: model.emailController,
                    hasBorder: true,
                    inputAction: TextInputAction.next,
                    validationType: Validations.requiredFieldValidator,
                    inputType: TextInputType.emailAddress,
                    isEnabled: true,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  App.columnSpacer(),
                  formFieldLabel(label: strings.password),
                  App.columnSpacer(),
                  TextFormFieldWidget(
                    controller: model.passController,
                    hasBorder: true,
                    obscure: model.secureText,
                    isEnabled: true,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validationType: Validations.requiredFieldValidator,
                    prefixIcon: IconButton(
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
                  App.columnSpacer(),
                  elevatedButton(
                    message: strings.login,
                    callBack: () {
                      if (model.formKey.currentState!.validate()) {
                        model.logInToFb(context);
                      }
                    },
                    backgroundColor: customColor.blueAccent,
                  ),
                  App.columnSpacer(),
                  Center(
                    child: RichText(
                      text: TextSpan(
                          text: strings.createAnAccount,
                          style: TextStyle(
                            color: customColor.black,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: strings.signUp,
                              style: TextStyle(
                                  fontStyle: App.textTheme.headline1!.fontStyle,
                                  color: customColor.skyBlue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // App.push(const RegistrationPage());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegistrationPage()));
                                },
                            ),
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildContainer() {
    return Container(
      height: App.height * 0.25,
      width: App.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(90)),
        color: customColor.blueLight,
      ),
      child: Center(
          child: Text(
        strings.todo,
        style: TextStyle(
            color: customColor.white,
            fontSize: 25,
            fontWeight: App.textTheme.headline5!.fontWeight),
      )),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (_, model, __) {
          return Login(model: model);
        });
  }
}
