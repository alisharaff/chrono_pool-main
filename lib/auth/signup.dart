import 'package:flutter/material.dart';

import '../components/crud.dart';
import '../components/valid.dart';
import '../constants/linksApi.dart';
import '../decoration/custom_text_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey();

  final Crud _crud = Crud();

  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  SignUp() async {
    // if (formstate.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    var response = await _crud.postRequest(linkSignUp, {
      "username": username.text,
      "email": email.text,
      "password": password.text
    });

    isLoading = false;
    setState(() {});

    if (response != null &&
        response.containsKey('status') &&
        response['status'] == "success") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("success", (route) => false);
    } else {
      print("sign up failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(10),
              child: ListView(
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
                            return validInput(val!, 5,
                                40); // Return the validation message or null

                            //return  validInput(val!, 3, 20);
                          },
                          savecontroller: username,
                          hint: "username",
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
                            await SignUp();
                          },
                          child: const Text("SignUp"),
                        ),
                        Container(height: 10),
                        InkWell(
                          child: const Text("Login"),
                          onTap: () {
                            Navigator.of(context).pushNamed("login");
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
