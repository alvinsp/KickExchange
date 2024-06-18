import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/auth_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/models/category_model.dart';
import 'package:kickexchange/models/product_model.dart';
import 'package:kickexchange/widgets/showDialogs.dart';
import 'package:kickexchange/widgets/showDialogsError.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  List<Data>? listProduct;
  List<DataCategory>? listCategory;
  DataCategory? selectedCategory;
  List<Data>? favoriteProducts = [];
  List<Data>? filteredProducts = [];
  bool isLoading = false;
  var state = ProductState.initial;
  var messageError = '';
  int idDataSelected = 1;
  Future<void> getProduct() async {
    state = ProductState.loading;

    try {
      String? token = await getToken();
      var response = await Dio().get(
        'http://192.168.100.107:3000/api/products/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        ProductModel productModel = ProductModel.fromJson(responseData);
        listProduct = productModel.data;
        filteredProducts = List<Data>.from(listProduct!);
        updateFavoriteStates();

        if (listProduct != null && listProduct!.isNotEmpty) {
          state = ProductState.success;
        } else {
          state = ProductState.nodata;
        }
      } else {
        messageError =
            'Failed to fetch products, status code: ${response.statusCode}';
        state = ProductState.error;
      }
    } catch (e) {
      messageError = 'Error fetching products: $e';
      state = ProductState.error;
    }
    notifyListeners();
  }

  Future<void> getCategories() async {
    state = ProductState.loading;
    notifyListeners();

    try {
      String? token = await getToken();
      var response = await Dio().get(
        'http://192.168.100.107:3000/api/categories/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        CategoryModel categoryModel = CategoryModel.fromJson(responseData);
        listCategory = categoryModel.data;

        if (listCategory != null && listCategory!.isNotEmpty) {
          state = ProductState.success;
        } else {
          state = ProductState.nodata;
        }
      } else {
        messageError =
            'Failed to fetch categories, status code: ${response.statusCode}';
        state = ProductState.error;
      }
    } catch (e) {
      messageError = 'Error fetching categories: $e';
      state = ProductState.error;
    }
    notifyListeners();
  }

  void filterProductsByCategoryId(int categoryId) {
    if (listProduct != null) {
      filteredProducts = listProduct!
          .where((product) => product.categoryId == categoryId)
          .toList();
      if (filteredProducts!.isEmpty) {
        state = ProductState.nodata;
      } else {
        state = ProductState.success;
      }
      notifyListeners();
    }
  }

  Data? getProductById(int id) {
    return listProduct?.firstWhere((product) => product.id == id);
  }

  void setSelectedCategory(DataCategory? category) {
    selectedCategory = category;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    isLoading = true;
    messageError = '';
    notifyListeners();

    try {
      String? token = await getToken();
      final response = await Dio().get(
        'http://192.168.100.107:3000/api/products/$query',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      List<dynamic> responseData = response.data;
      ProductModel productModel = ProductModel.fromJson(responseData);
      listProduct = productModel.data;
    } catch (error) {
      messageError = 'Error fetching products: $error';
      const Center(
        child: Text(
          "Error Fetching Products",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(BuildContext context) async {
    try {
      String? token = await getToken();

      int? categoryId = selectedCategory?.id;

      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "price": priceController.text,
        "categoryId": categoryId,
        "url": urlController.text
      };

      var response = await Dio().post(
        'http://192.168.100.107:3000/api/products/',
        data: requestModel,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
                "SUCCESS SELL PRODUCT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              24.0.height,
              const Text(
                "Your product successfull to sell",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        nameController.clear();
        qtyController.clear();
        priceController.clear();
        urlController.clear();
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
                "FAILED SELL PRODUCT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              24.0.height,
              Text(
                "Failed to add product ${response.statusCode}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error adding product: $e');
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
              "FAILED SELL PRODUCT",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
            ),
            24.0.height,
            const Text(
              "Error adding product",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  Future editProduct(BuildContext context, int id) async {
    try {
      String? token = await getToken();

      int? categoryId = selectedCategory?.id;
      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "price": priceController.text,
        "categoryId": categoryId,
        "url": urlController.text
      };

      var response = await Dio().put(
        'http://192.168.100.107:3000/api/products/$id',
        data: requestModel,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
                "SUCCESS EDIT PRODUCT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              24.0.height,
              const Text(
                "Your product successfull to Edit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        getProduct();
        nameController.clear();
        qtyController.clear();
        priceController.clear();
        urlController.clear();
      } else {
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
                "FAILED EDIT PRODUCT",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
              ),
              24.0.height,
              Text(
                "Failed to edit product, your response: ${response.statusCode}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
    } catch (e) {
      messageError = e.toString();
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
              "FAILED EDIT PRODUCT",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
            ),
            24.0.height,
            const Text(
              "Error edit product",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  Future deleteProduct(BuildContext context, int id) async {
    try {
      String? token = await getToken();
      await Dio().delete(
        'http://192.168.100.107:3000/api/products/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      getProduct();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future<void> addFavorite(BuildContext context, int productId) async {
    try {
      String? token = await getToken();
      var response = await Dio().post(
        'http://192.168.100.107:3000/api/favorites',
        data: {'productId': productId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        Data? product = getProductById(productId);
        if (product != null) {
          product.isFavorite = true;
          favoriteProducts?.add(product);
        }
        saveFavorites();
        notifyListeners();
      } else {
        throw Exception('Failed to add favorite');
      }
    } catch (e) {
      print('Error adding favorite: $e');
      notifyListeners();
    }
  }

  Future<void> removeFavorite(BuildContext context, int productId) async {
    try {
      String? token = await getToken();
      var response = await Dio().delete(
        'http://192.168.100.107:3000/api/favorites/$productId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Data? product = getProductById(productId);
        if (product != null) {
          product.isFavorite = false;
          favoriteProducts?.removeWhere((p) => p.id == productId);
        }
        saveFavorites();
        notifyListeners();
      } else {
        throw Exception('Failed to remove favorite');
      }
    } catch (e) {
      print('Error removing favorite: $e');
      notifyListeners();
    }
  }

  Future<void> getFavorites() async {
    state = ProductState.loading;
    notifyListeners();
    try {
      String? token = await getToken();
      var response = await Dio().get(
        'http://192.168.100.107:3000/api/favorites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        ProductModel productModel = ProductModel.fromJson(responseData);
        favoriteProducts = productModel.data;

        if (favoriteProducts != null && favoriteProducts!.isNotEmpty) {
          state = ProductState.success;
        } else {
          state = ProductState.nodata;
        }
        updateFavoriteStates();
      } else {
        state = ProductState.error;
      }
    } catch (e) {
      state = ProductState.error;
    }
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds =
        favoriteProducts!.map((product) => product.id.toString()).toList();
    prefs.setStringList('favoriteProducts', favoriteIds);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteProducts');
    if (favoriteIds != null) {
      favoriteProducts = favoriteIds
          .map((id) =>
              listProduct!.firstWhere((product) => product.id == int.parse(id)))
          .toList();
      updateFavoriteStates();
    }
  }

  void updateFavoriteStates() {
    for (var product in listProduct!) {
      product.isFavorite = favoriteProducts!.any((fav) => fav.id == product.id);
    }
    notifyListeners();
  }
}

enum ProductState { initial, loading, success, error, nodata }
