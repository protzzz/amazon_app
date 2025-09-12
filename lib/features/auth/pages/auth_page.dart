import 'package:amazon_clone_app/common/widgets/custom_button.dart';
import 'package:amazon_clone_app/common/widgets/custom_textfield.dart';
import 'package:amazon_clone_app/constants/global_variables.dart';
import 'package:amazon_clone_app/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth { login, signup }

class AuthPage extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthPage> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _nameController =
      TextEditingController();

  void signUpUser() {
    authService.signUpUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color:
                      _auth == Auth.signup
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                  border: Border.all(
                    color:
                        _auth == Auth.signup
                            ? GlobalVariables.secondaryColor
                            : GlobalVariables.greyBackgroundColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: Radio<Auth>(
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.signup,
                        groupValue: _auth,
                        onChanged: (Auth? value) {
                          setState(() {
                            _auth = value!;
                          });
                        },
                      ),
                    ),
                    if (_auth == Auth.signup)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        color: GlobalVariables.backgroundColor,
                        child: Form(
                          key: _signUpFormKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _nameController,
                                hintText: 'Name',
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'E-mail',
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password',
                              ),
                              const SizedBox(height: 15),
                              CustomButton(
                                text: 'Sign Up',
                                onTap: () {
                                  if (_signUpFormKey.currentState!
                                      .validate()) {
                                    signUpUser();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color:
                      _auth == Auth.login
                          ? GlobalVariables.backgroundColor
                          : GlobalVariables.greyBackgroundColor,
                  border: Border.all(
                    color:
                        _auth == Auth.login
                            ? GlobalVariables.secondaryColor
                            : GlobalVariables.greyBackgroundColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Sign-In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Radio(
                        activeColor: GlobalVariables.secondaryColor,
                        value: Auth.login,
                        groupValue: _auth,
                        onChanged: (Auth? value) {
                          setState(() {
                            _auth = value!;
                          });
                        },
                      ),
                    ),
                    if (_auth == Auth.login)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        color: GlobalVariables.backgroundColor,
                        child: Form(
                          key: _signInFormKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'E-mail',
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password',
                              ),
                              const SizedBox(height: 15),
                              CustomButton(
                                text: 'Sign Up',
                                onTap: () {},
                              ),
                            ],
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
}
