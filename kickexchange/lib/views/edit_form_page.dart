import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/models/category_model.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:kickexchange/widgets/buttons.dart';
import 'package:kickexchange/widgets/textFormFields.dart';
import 'package:provider/provider.dart';

class EditFormPage extends StatelessWidget {
  const EditFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as int;
    var productController = context.watch<ProductController>();
    var product = productController.getProductById(productId);
    productController.nameController =
        TextEditingController(text: product?.name);
    productController.priceController =
        TextEditingController(text: product?.price.toString());
    productController.qtyController =
        TextEditingController(text: product?.qty.toString());
    productController.urlController = TextEditingController(text: product?.url);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const Row(
                children: [
                  Icon(Icons.edit_note_sharp),
                  SizedBox(
                    width: 4.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Edit Your Product",
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
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                              Border.all(color: AppColors.black, width: 1.5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: DropdownButton<DataCategory>(
                          value: productController.selectedCategory,
                          hint: const Text('Select Category'),
                          onChanged: (DataCategory? newValue) {
                            productController.setSelectedCategory(newValue);
                          },
                          icon: Icon(Icons
                              .arrow_drop_down), // Icon yang digunakan untuk menampilkan dropdown
                          underline: Container(
                            height: 0, // Tinggi border bawah
                          ),
                          items: productController.listCategory!
                              .map((DataCategory category) {
                            return DropdownMenuItem<DataCategory>(
                              value: category,
                              child: Text(
                                category.name ?? '',
                                style: TextStyle(
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
              32.0.height,
              Buttons(
                text: 'EDIT',
                onPressed: () {
                  context
                      .read<ProductController>()
                      .editProduct(context, productId.toInt());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
