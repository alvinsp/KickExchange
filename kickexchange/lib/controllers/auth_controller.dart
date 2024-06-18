import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final formKeyLogin = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var loginState = StateLogin.initial;
  bool obscurePassword = true;
  String? _jwtToken;

  Future<void> processRegister(
      BuildContext context, VoidCallback onSuccess) async {
    if (formKeyRegister.currentState!.validate()) {
      try {
        var requestModel = {
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        };
        var response = await Dio().post(
          'http://192.168.100.107:3000/api/auth/register',
          data: requestModel,
        );

        if (response.statusCode == 200) {
          // await FirebaseAuth.instance.createUserWithEmailAndPassword(
          //   email: emailController.text,
          //   password: passwordController.text,
          // );
          loginState = StateLogin.success;
          showAlertSuccess(context, 'REGISTRATION SUCCESS',
              "Your Email Succesfull Registration", onSuccess);
        }
      } catch (e) {
        showAlertError("REGISTRATION FAILED", context, 500);
      }
    } else {
      showAlertError("REGISTRATION FAILED", context, 400);
    }
  }

  Future<void> processLogin(BuildContext context) async {
    if (formKeyLogin.currentState!.validate()) {
      try {
        var requestModel = {
          'email': emailController.text,
          'password': passwordController.text,
        };
        var response = await Dio().post(
          'http://192.168.100.107:3000/api/auth/login',
          data: requestModel,
        );

        if (response.statusCode == 200) {
          // await FirebaseAuth.instance.signInWithEmailAndPassword(
          //   email: emailController.text,
          //   password: passwordController.text,
          // );
          _jwtToken = response.data['accessToken'];
          await _saveToken(_jwtToken!);
          var userData = response.data['user'];
          loginState = StateLogin.success;
          showAlertSuccess(
              context, 'LOGIN SUCCESS', 'Welcome to KickExchange App', () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/navigation', (route) => false,
                arguments: userData);
          });
        } else {
          showAlertError("LOGIN FAILED", context, response.statusCode ?? 500);
        }
      } on DioException {
        showAlertError("LOGIN FAILED", context, 500);
      } catch (e) {
        showAlertError("LOGIN FAILED", context, 500);
      }
    } else {
      showAlertError("LOGIN FAILED", context, 400);
    }
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void showAlertError(String error, BuildContext context, int statusCode) {
    final errorMessages = {
      400: "Please check your input.",
      401: "Unauthorized: Incorrect email or password.",
      500: "Email has been registered or Wrong Email or Password",
    };

    String errorMessage =
        errorMessages[statusCode] ?? "Error: An unexpected error occurred.";

    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(
                    'https://lottie.host/6ed10df5-aa1a-40e5-ba80-52d4c76d1c2a/1oZTVb0vTg.json',
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                  24.0.height,
                  Text(
                    error,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 24),
                  ),
                  24.0.height,
                  Text(
                    errorMessage,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  28.0.height,
                ],
              ),
              actions: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(AppColors.red),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void alertFirebaseError(BuildContext context, FirebaseAuthException error) {
  //   loginState = StateLogin.error;
  //   int statusCode = _getFirebaseAuthErrorCode(error.code);
  //   showAlertError("FIREBASE ERROR", context, statusCode);
  // }

  // int _getFirebaseAuthErrorCode(String errorCode) {
  //   switch (errorCode) {
  //     case 'invalid-email':
  //       return 400;
  //     case 'user-disabled':
  //       return 403;
  //     case 'user-not-found':
  //       return 404;
  //     case 'wrong-password':
  //       return 401;
  //     default:
  //       return 500;
  //   }
  // }
}

void showAlertSuccess(BuildContext context, String success, String message,
    VoidCallback onSuccess) {
  showDialog(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network(
                  'https://lottie.host/3263343e-d390-4a9e-8503-0e2e753a45ee/JoSltkXv65.json',
                  height: 240,
                  fit: BoxFit.fill,
                ),
                24.0.height,
                Text(
                  success,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 24),
                ),
                24.0.height,
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                28.0.height,
              ],
            ),
            actions: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onSuccess();
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(AppColors.green),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  Navigator.pushReplacementNamed(context, '/auth');
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

enum StateLogin { initial, success, error }
