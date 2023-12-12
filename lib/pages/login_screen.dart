// ignore_for_file: use_build_context_synchronously

import 'package:DeedBalancer/service/config.dart';
import 'package:DeedBalancer/models/login/login_request_model.dart';
import 'package:DeedBalancer/service/api_service.dart';
import 'package:DeedBalancer/service/access_token.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAPICallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;

  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    String? token = await AccessToken.getToken();

    if (token != null && token.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProgressHUD(
      key: UniqueKey(),
      inAsyncCall: isAPICallProcess,
      opacity: 0.3,
      child: Form(
        key: globalFormKey,
        child: _loginUI(context),
      ),
    ));
  }

  Widget _loginUI(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("images/login-ilustrasi.png",
                        height: 220.0),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: FormHelper.inputFieldWidget(
                        context, "username", "Username", (onValidateVal) {
                      if (onValidateVal.isEmpty) {
                        return "Username can't be empty";
                      }
                      return null;
                    }, (onSavedVal) {
                      username = onSavedVal;
                    },
                        borderRadius: 8.0,
                        borderColor: Colors.black38,
                        borderFocusColor: Colors.black87,
                        hintColor: Colors.black87),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                      child: FormHelper.inputFieldWidget(
                          context, "password", "Password",
                          obscureText: hidePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Colors.black.withOpacity(0.7),
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            iconSize: 20,
                          ), (onValidateVal) {
                    if (onValidateVal.isEmpty) {
                      return "Password can't be empty";
                    }
                    return null;
                  }, (onSavedVal) {
                    password = onSavedVal;
                  },
                          borderRadius: 8.0,
                          borderColor: Colors.black38,
                          borderFocusColor: Colors.black87,
                          hintColor: Colors.black87)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: FormHelper.submitButton(
                      "Login",
                      borderRadius: 8.0,
                      width: 180,
                      height: 40.0,
                      btnColor: const Color(0xFFFFE6D4),
                      txtColor: Colors.black,
                      borderColor: const Color.fromARGB(255, 255, 192, 147),
                      () {
                        if (validateAndSave()) {
                          setState(() {
                            isAPICallProcess = true;
                          });

                          LoginRequestModel model = LoginRequestModel(
                              username: username!, password: password!);

                          APIService.login(model).then((response) => {
                                setState(() {
                                  isAPICallProcess = false;
                                }),
                                if (response)
                                  {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/home', (route) => false)
                                  }
                                else
                                  {
                                    FormHelper.showSimpleAlertDialog(
                                        context,
                                        Config.appName,
                                        "Invalid Username/Password",
                                        "OK", () {
                                      Navigator.pop(context);
                                    })
                                  }
                              });
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30.0, bottom: 15.0),
                    child: const Text(
                      "Are you not registered?",
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 255, 177, 122),
                      backgroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: const Size(180.0, 40.0),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Register',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 192, 147)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
