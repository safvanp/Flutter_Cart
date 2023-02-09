import 'package:flutter/material.dart';
import 'package:flutter_cart/provider/auth_provider.dart';
import 'package:flutter_cart/utils/constants.dart';

import 'package:flutter_cart/widget/progress_status.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false, showPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username = "", _password = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    doLogin() {
      setState(() {
        _isLoading = true;
      });
      final FormState form = _formKey.currentState!;
      if (!form.validate()) {
        showInSnackBar('Please fix the errors in red before submitting.');
      } else {
        form.save();
        final Future<Map<String, dynamic>> message =
            auth.login(_username, _password);
        message.then((response) {
          if (response['status']) {
            redirect(true);
          } else {
            showInSnackBar(response['message']['message'].toString());
          }
        });
      }
    }

    return Scaffold(
      body: ProgressStatus(
        color: kSecondaryColor,
        inAsyncCall: _isLoading,
        opacity: 0.0,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
        child: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Welcome to Flutter Cart'),
                    const Icon(
                      Icons.person_pin_rounded,
                      size: 70,
                      color: kPrimaryColor,
                    ),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(29),
                                      ),
                                      child: TextFormField(
                                        key: const Key("_username"),
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.person,
                                            color: kPrimaryColor,
                                          ),
                                          hintText: "User Name",
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.text,
                                        onSaved: (String? value) {
                                          _username = value!.trim();
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Username is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: size.width * 0.8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(29),
                                      ),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          icon: const Icon(
                                            Icons.lock,
                                            color: kPrimaryColor,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.visibility),
                                            color: kPrimaryColor,
                                            onPressed: () => setState(() =>
                                                showPassword = !showPassword),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        obscureText: showPassword,
                                        onSaved: (String? value) {
                                          _password = value!.trim();
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Password is required';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: size.width * 0.8,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(29),
                                        child: TextButton(
                                          onPressed: doLogin,
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 40),
                                            backgroundColor: kPrimaryColor,
                                          ),
                                          child: const Text(
                                            "LOGIN",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: size.width * 0.8,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(29),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor: kPrimaryColor),
                                          child:
                                              const Text("Create an account ?"),
                                          onPressed: () {
                                            // Navigator.pushNamedAndRemoveUntil(
                                            //   context,
                                            //   '/createUser',
                                            //   ModalRoute.withName('/createUser'),
                                            // );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  redirect(bool value) {
    setState(() {
      _isLoading = true;
    });

    if (value) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
