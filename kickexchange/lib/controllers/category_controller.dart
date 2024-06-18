import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/auth_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/widgets/showDialogs.dart';
import 'package:kickexchange/widgets/showDialogsError.dart';
import 'package:lottie/lottie.dart';

class CategoryController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  Future<void> addCategory(BuildContext context) async {
    try {
      String? token = await getToken();
      if (token == null) {
        return print("token not found");
      }

      var requestModel = {
        "name": nameController.text,
        "image": imageController.text,
      };

      var response = await Dio().post(
        'http://192.168.100.107:3000/api/categories/',
        data: requestModel,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Product added successfully: ${response.data}');
        showDialogs(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.network(
                'https://lottie.host/b9e2b980-2a7b-454e-8159-21d4fd8dc90b/5S3wEVzedT.json',
                height: 180,
                fit: BoxFit.fill,
              ),
              24.0.height,
              const Text(
                "SUCCESS ADD CATEGORIES",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              24.0.height,
              const Text(
                "New categories successfull to added",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        nameController.clear();
        imageController.clear();
      } else {
        print('Failed to add product, status code: ${response.statusCode}');
        showDialogsError(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.network(
                'https://lottie.host/6ed10df5-aa1a-40e5-ba80-52d4c76d1c2a/1oZTVb0vTg.json',
                height: 180,
                fit: BoxFit.fill,
              ),
              24.0.height,
              const Text(
                "FAILED ADD CATEGORIES",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              24.0.height,
              Text(
                "Failed to add new category ${response.statusCode}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
