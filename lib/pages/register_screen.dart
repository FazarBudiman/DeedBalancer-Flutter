import 'package:DeedBalancer/service/config.dart';
import 'package:DeedBalancer/models/register/register_request_model.dart';
import 'package:DeedBalancer/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isAPICallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? nama;
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProgressHUD(
            key: UniqueKey(),
            inAsyncCall: isAPICallProcess,
            child: Form(
              key: globalFormKey,
              child: _registerUI(context),
            )));
  }

  Widget _registerUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset("images/register-ilustrasi.png", height: 210.0),
          ),
          const SizedBox(
            height: 30.0,
          ),
          FormHelper.inputFieldWidget(context, "nama", "Name", (onValidateVal) {
            if (onValidateVal.isEmpty) {
              return "Name can't be empty";
            }
            return null;
          }, (onSavedVal) {
            nama = onSavedVal;
          },
              borderRadius: 8.0,
              borderColor: Colors.black38,
              borderFocusColor: Colors.black87,
              hintColor: Colors.black87),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
            child: FormHelper.inputFieldWidget(context, "username", "Username",
                (onValidateVal) {
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
          Padding(
              padding: const EdgeInsets.only(
                bottom: 15.0,
              ),
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
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      )), (onValidateVal) {
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
          Center(
            child: FormHelper.submitButton(
              "Register",
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

                  RegisterRequestModel model = RegisterRequestModel(
                      nama: nama!, username: username!, password: password!);

                  APIService.register(model).then((response) => {
                        setState(() {
                          isAPICallProcess = false;
                        }),
                        if (response)
                          {
                            FormHelper.showSimpleAlertDialog(context,
                                Config.appName, "Register Success", "OK", () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            })
                          }
                        else
                          {
                            FormHelper.showSimpleAlertDialog(
                                context, Config.appName, "Register Gagal", "OK",
                                () {
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
              "Do you have an acoount?",
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
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Login',
                style: TextStyle(color: Color.fromARGB(255, 255, 192, 147))),
          ),
        ],
      ),
    );
  }

  // Widget _registerUI(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Center(
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.height,
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: 10.0,
  //               ),
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Image.asset("images/register-ilustrasi.png",
  //                     height: 210.0),
  //               ),
  //               const SizedBox(
  //                 height: 30.0,
  //               ),
  //               FormHelper.inputFieldWidget(context, "nama", "Name",
  //                   (onValidateVal) {
  //                 if (onValidateVal.isEmpty) {
  //                   return "Name can't be empty";
  //                 }
  //                 return null;
  //               }, (onSavedVal) {
  //                 nama = onSavedVal;
  //               },
  //                   borderRadius: 8.0,
  //                   borderColor: Colors.black38,
  //                   borderFocusColor: Colors.black87,
  //                   hintColor: Colors.black87),
  //               Padding(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 0, vertical: 15.0),
  //                 child: FormHelper.inputFieldWidget(
  //                     context, "username", "Username", (onValidateVal) {
  //                   if (onValidateVal.isEmpty) {
  //                     return "Username can't be empty";
  //                   }
  //                   return null;
  //                 }, (onSavedVal) {
  //                   username = onSavedVal;
  //                 },
  //                     borderRadius: 8.0,
  //                     borderColor: Colors.black38,
  //                     borderFocusColor: Colors.black87,
  //                     hintColor: Colors.black87),
  //               ),
  //               Padding(
  //                   padding: const EdgeInsets.only(
  //                     bottom: 15.0,
  //                   ),
  //                   child: FormHelper.inputFieldWidget(
  //                       context, "password", "Password",
  //                       obscureText: hidePassword,
  //                       suffixIcon: IconButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               hidePassword = !hidePassword;
  //                             });
  //                           },
  //                           color: Colors.black.withOpacity(0.7),
  //                           icon: Icon(
  //                             hidePassword
  //                                 ? Icons.visibility_off
  //                                 : Icons.visibility,
  //                           )), (onValidateVal) {
  //                     if (onValidateVal.isEmpty) {
  //                       return "Password can't be empty";
  //                     }
  //                     return null;
  //                   }, (onSavedVal) {
  //                     password = onSavedVal;
  //                   },
  //                       borderRadius: 8.0,
  //                       borderColor: Colors.black38,
  //                       borderFocusColor: Colors.black87,
  //                       hintColor: Colors.black87)),
  //               Center(
  //                 child: FormHelper.submitButton(
  //                   "Register",
  //                   borderRadius: 8.0,
  //                   width: 180,
  //                   height: 40.0,
  //                   btnColor: const Color(0xFFFFE6D4),
  //                   txtColor: Colors.black,
  //                   borderColor: const Color.fromARGB(255, 255, 192, 147),
  //                   () {
  //                     if (validateAndSave()) {
  //                       setState(() {
  //                         isAPICallProcess = true;
  //                       });

  //                       RegisterRequestModel model = RegisterRequestModel(
  //                           nama: nama!,
  //                           username: username!,
  //                           password: password!);

  //                       APIService.register(model).then((response) => {
  //                             setState(() {
  //                               isAPICallProcess = false;
  //                             }),
  //                             if (response)
  //                               {
  //                                 FormHelper.showSimpleAlertDialog(
  //                                     context,
  //                                     Config.appName,
  //                                     "Register Success",
  //                                     "OK", () {
  //                                   Navigator.pushNamedAndRemoveUntil(
  //                                       context, '/login', (route) => false);
  //                                 })
  //                               }
  //                             else
  //                               {
  //                                 FormHelper.showSimpleAlertDialog(
  //                                     context,
  //                                     Config.appName,
  //                                     "Register Gagal",
  //                                     "OK", () {
  //                                   Navigator.pop(context);
  //                                 })
  //                               }
  //                           });
  //                     }
  //                   },
  //                 ),
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.only(top: 30.0, bottom: 15.0),
  //                 child: const Text(
  //                   "Do you have an acoount?",
  //                 ),
  //               ),
  //               TextButton(
  //                 style: TextButton.styleFrom(
  //                   foregroundColor: const Color.fromARGB(255, 255, 177, 122),
  //                   backgroundColor: Colors.white70,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                   ),
  //                   minimumSize: const Size(180.0, 40.0),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pushNamed(context, '/login');
  //                 },
  //                 child: const Text('Login',
  //                     style:
  //                         TextStyle(color: Color.fromARGB(255, 255, 192, 147))),
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

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
