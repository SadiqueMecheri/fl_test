import 'package:fl_test/Const/shared_preferences.dart';
import 'package:fl_test/Const/utils.dart';
import 'package:fl_test/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late final String? isLoggedIn;

  @override
  void initState() {
    _checkSession();
    super.initState();
  }

  Future _checkSession() async {
    isLoggedIn = await Store.getLoggedIn();
    if (isLoggedIn == "yes") {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                backgroundColor2,
                backgroundColor2,
                backgroundColor4,
              ],
            ),
          ),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Hello Again!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Wellcome back vou've been missed!",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14, color: textColor2, height: 1.2),
                  ),
                  const SizedBox(height: 100),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 22,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Enter email",
                        hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: Consumer<LoginProvider>(
                      builder: (context, loginProvider, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: !loginProvider
                              .isPasswordVisible, // Use provider's value
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 22,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(
                              color: Colors.black45,
                              fontSize: 13,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginProvider.isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.black26,
                              ),
                              onPressed: () {
                                loginProvider.togglePasswordVisibility();
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            } else if (value.length < 6) {
                              return 'Password must be at least \n6 characters';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(height: size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        loginProvider.isLoading
                            ? const CircularProgressIndicator()
                            : InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final email = _emailController.text;
                                    final password = _passwordController.text;
                                    await loginProvider.login(
                                        email, password, context);
                                    if (loginProvider.errorMessage != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            loginProvider.errorMessage!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  width: size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: size.height * 0.06),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
