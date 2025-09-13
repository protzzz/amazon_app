import 'package:amazon_clone_app/core/constants/utils.dart';
import 'package:amazon_clone_app/features/auth/cubit/auth_cubit.dart';
import 'package:amazon_clone_app/features/auth/widgets/custom_button.dart';
import 'package:amazon_clone_app/features/auth/widgets/custom_textfield.dart';
import 'package:amazon_clone_app/core/constants/global_variables.dart';
import 'package:amazon_clone_app/features/auth/repository/auth_remote_repository.dart';
import 'package:amazon_clone_app/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Auth { login, signup }

class AuthPage extends StatefulWidget {
  static const String routeName = '/auth-page';
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthPage> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final AuthRemoteRepository authRemoteRepository =
      AuthRemoteRepository();

  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _nameController =
      TextEditingController();

  void signUpUser() {
    if (_signUpFormKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
      );
    }
  }

  void loginUser() {
    if (_loginFormKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showSnackbar(context, state.error);
          } else if (state is AuthSignUp) {
            showSnackbar(context, 'Account created! Login now!');
          } else if (state is AuthLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routeName,
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
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
                                : GlobalVariables
                                    .greyBackgroundColor,
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
                            activeColor:
                                GlobalVariables.secondaryColor,
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
                                    validator: (value) {
                                      if (value!.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  CustomButton(
                                    text: 'Sign Up',
                                    onTap: signUpUser,
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
                                : GlobalVariables
                                    .greyBackgroundColor,
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
                            activeColor:
                                GlobalVariables.secondaryColor,
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
                              key: _loginFormKey,
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
                                    validator: (value) {
                                      if (value!.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  CustomButton(
                                    text: 'Sign In',
                                    onTap: loginUser,
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
          );
        },
      ),
    );
  }
}
