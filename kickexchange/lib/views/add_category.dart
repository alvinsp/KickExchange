import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/category_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:kickexchange/widgets/buttons.dart';
import 'package:kickexchange/widgets/textFormFields.dart';
import 'package:provider/provider.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<CategoryController>(
          builder: (context, categoryController, child) {
        categoryController.nameController = TextEditingController();
        categoryController.imageController = TextEditingController();
        return Form(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const Row(
                  children: [
                    Icon(Icons.category),
                    SizedBox(
                      width: 4.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Add New Category",
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
                  controller: categoryController.nameController,
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
                  controller: categoryController.imageController,
                  obscureText: false,
                  labelText: "Image URL",
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'image cant be empty';
                    }
                    return null;
                  },
                  textInputType: TextInputType.text,
                  borderColor: AppColors.black,
                ),
                32.0.height,
                Buttons(
                  text: 'ADD',
                  onPressed: () {
                    context.read<CategoryController>().addCategory(context);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
