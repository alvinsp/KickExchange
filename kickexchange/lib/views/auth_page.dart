import 'package:flutter/material.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/widgets/buttons.dart';
import 'package:kickexchange/widgets/textFormFields.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_Controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginPage = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthController>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: isLoginPage
                ? authProvider.formKeyLogin
                : authProvider.formKeyRegister,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome To",
                    style: TextStyle(
                        fontFamily: 'raleway',
                        fontSize: 42,
                        fontWeight: FontWeight.w900),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Kick",
                        style: TextStyle(
                          fontFamily: 'raleway',
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        "Exchange",
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                  16.0.height,
                  const Text(
                    "Please fill your account",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.grey),
                  ),
                  56.0.height,
                  isLoginPage
                      ? 0.0.height
                      : Textformfields(
                          controller: authProvider.usernameController,
                          obscureText: false,
                          labelText: "Username",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username cannot empty';
                            }
                            return null;
                          },
                          textInputType: TextInputType.text,
                          borderColor: AppColors.black,
                        ),
                  24.0.height,
                  Textformfields(
                    controller: authProvider.emailController,
                    obscureText: false,
                    labelText: "Email",
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Masukkan alamat email yang valid';
                      }
                      return null;
                    },
                    textInputType: TextInputType.emailAddress,
                    borderColor: AppColors.black,
                  ),
                  24.0.height,
                  Textformfields(
                    textInputType: TextInputType.text,
                    controller: authProvider.passwordController,
                    labelText: "Password",
                    obscureText: authProvider.obscurePassword,
                    validator: (value) => value.isNotEmpty && value.length >= 8,
                    onSuffixIconPressed: () {
                      context.read<AuthController>().actionObscurePassword();
                    },
                    borderColor: AppColors.black,
                  ),
                  32.0.height,
                  Buttons(
                    text: isLoginPage ? 'Login' : 'Register',
                    onPressed: () {
                      if (isLoginPage) {
                        context.read<AuthController>().processLogin(context);
                      } else {
                        context.read<AuthController>().processRegister(
                          context,
                          () {
                            setState(() {
                              isLoginPage = true;
                            });
                          },
                        );
                      }
                    },
                  ),
                  26.0.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLoginPage
                            ? 'Dont have an account?'
                            : 'Have an account?',
                        style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: Text(
                          isLoginPage ? 'Register' : 'Login',
                          style: const TextStyle(
                              color: AppColors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
