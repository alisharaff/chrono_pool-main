import 'package:chrono_pool/components/crud.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../components/valid.dart';
import '../constants/linksApi.dart';
import '../decoration/custom_text_form.dart';
late SharedPreferences sharedPref ;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final Crud _crud = Crud();

  bool isLoading = false;

  login() async {
    isLoading = true;
    setState(() {});

    var response = await _crud.postRequest(
        linkLogin, {"email": email.text,
                    "password": password.text});

    isLoading = false;
    setState(() {});


    if (response != null &&
        response.containsKey('status') &&
        response['status'] == "success") {

      if (response['data'] != null) {
        if (response['data']['id'] != null) {
          sharedPref.setString("id", response['data']['id'].toString());
        }

        if (response['data']['username'] != null) {
          sharedPref.setString("username", response['data']['username']);
        }

        if (response['data']['email'] != null) {
          sharedPref.setString("email", response['data']['email']);
        }
      }

      Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
    } else {
      // AwesomeDialog(
      //     context: context,
      //     title: "Attention!",
      //     body: const Text("Your email or password aren't correct!"))
      //   .show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Form(
                    key: formstate,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/blackball.jpeg",
                          width: 200,
                          height: 200,
                        ),
                        CustomTextForm(
                          valid: (val) {
                            return validInput(val!, 5, 40);
                          },
                          savecontroller: email,
                          hint: "email",
                        ),
                        CustomTextForm(
                          valid: (val) {
                            return validInput(val!, 3, 50);
                          },
                          savecontroller: password,
                          hint: "password",
                        ),
                        MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 10),
                          onPressed: () async {
                            await login();
                          },
                          child: const Text("login"),
                        ),
                        Container(height: 10),
                        InkWell(
                          child: const Text("Sign up"),
                          onTap: () {
                            Navigator.of(context).pushNamed("signup");
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
