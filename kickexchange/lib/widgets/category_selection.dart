import 'package:flutter/material.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/models/category_model.dart';

class CategorySelection extends StatelessWidget {
  final List<DataCategory> categories;
  final Function(int) onCategorySelected;

  const CategorySelection({super.key, 
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          24.0.height,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    onCategorySelected(category.id!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: Image.network(
                            category.image!,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
