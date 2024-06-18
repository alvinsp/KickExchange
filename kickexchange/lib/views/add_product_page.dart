import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/models/category_model.dart';
import 'package:kickexchange/views/add_category.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:kickexchange/widgets/buttons.dart';
import 'package:kickexchange/widgets/textFormFields.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<ProductController>(
          builder: (context, productController, child) {
        productController.nameController = TextEditingController();
        productController.priceController = TextEditingController();
        productController.qtyController = TextEditingController();
        productController.urlController = TextEditingController();
        return Form(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_bag_outlined),
                    SizedBox(
                      width: 4.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Sell Your Product",
                          style: TextStyle(
                            fontFamily: 'raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                32.0.height,
                Textformfields(
                  controller: productController.nameController,
                  obscureText: false,
                  labelText: "Name",
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Text cant be empty';
                    }
                    return null;
                  },
                  textInputType: TextInputType.text,
                  borderColor: AppColors.black,
                ),
                24.0.height,
                Textformfields(
                  controller: productController.priceController,
                  obscureText: false,
                  labelText: "Price",
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Price cant be empty';
                    }
                    return null;
                  },
                  textInputType: TextInputType.number,
                  borderColor: AppColors.black,
                ),
                24.0.height,
                Textformfields(
                  controller: productController.qtyController,
                  obscureText: false,
                  labelText: "Qty",
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Qty cant be empty';
                    }
                    return null;
                  },
                  textInputType: TextInputType.number,
                  borderColor: AppColors.black,
                ),
                24.0.height,
                Textformfields(
                  controller: productController.urlController,
                  obscureText: false,
                  labelText: "Url Image",
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Url cant be empty';
                    }
                    return null;
                  },
                  textInputType: TextInputType.text,
                  borderColor: AppColors.black,
                ),
                24.0.height,
                productController.listCategory == null ||
                        productController.listCategory!.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'No category available',
                          style: TextStyle(
                            color: AppColors.black,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: AppColors.black, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: DropdownButton<DataCategory>(
                            value: productController.selectedCategory,
                            hint: const Text('Select Category'),
                            onChanged: (DataCategory? newValue) {
                              productController.setSelectedCategory(newValue);
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                            underline: Container(
                              height: 0,
                            ),
                            items: productController.listCategory!
                                .map((DataCategory category) {
                              return DropdownMenuItem<DataCategory>(
                                value: category,
                                child: Text(
                                  category.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                // Textformfields(
                //   controller: productController.categoryIdController,
                //   obscureText: false,
                //   labelText: "Id Category",
                //   validator: (value) {
                //     if (value.isEmpty) {
                //       return 'Id Category cant be empty';
                //     }
                //     return null;
                //   },
                //   textInputType: TextInputType.number,
                //   borderColor: AppColors.black,
                // ),
                32.0.height,
                Buttons(
                  text: 'SELL',
                  onPressed: () {
                    context.read<ProductController>().addProduct(context);
                  },
                ),
                32.0.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Added new Category? ",
                      style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const AddCategoryPage()),
                          );
                        },
                        child: const Text(
                          "Create",
                          style: TextStyle(
                              color: AppColors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
