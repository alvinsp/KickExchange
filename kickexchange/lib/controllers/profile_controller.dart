import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/auth_controller.dart';
import 'package:kickexchange/models/profile_model.dart';

class ProfileController extends ChangeNotifier {
  ProfileModel? profileData;
  bool isLoading = true;
  File? _image;
  ProfileState state = ProfileState.initial;

  File? get image => _image;

  ProfileController() {
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      state = ProfileState.loading;
      notifyListeners();

      String? token = await getToken();
      if (token == null) {
        state = ProfileState.nodata;
        notifyListeners();
        return;
      }

      var response = await Dio().get(
        'http://192.168.100.107:3000/api/users/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        profileData = ProfileModel.fromJson(response.data);
        state = ProfileState.success;
      } else {
        profileData = null;
        state = ProfileState.nodata;
      }
    } catch (e) {
      profileData = null;
      state = ProfileState.error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadImage(String filePath) async {
    try {
      state = ProfileState.loading;
      notifyListeners();

      String? token = await getToken();
      if (token == null) {
        state = ProfileState.error;
        notifyListeners();
        return;
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: 'profile.jpg'),
      });

      var response = await Dio().patch(
        'http://192.168.100.107:3000/api/users/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        profileData = ProfileModel.fromJson(response.data);
        state = ProfileState.success;
      } else {
        state = ProfileState.error;
      }
    } catch (e) {
      state = ProfileState.error;
    } finally {
      notifyListeners();
    }
  }
}

enum ProfileState { initial, loading, success, error, nodata }
