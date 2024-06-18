import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:kickexchange/widgets/category_selection.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    final productController = context.read<ProductController>();
    productController.getProduct();
    productController.getCategories();
    productController.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<ProductController>(
        builder: (context, productController, child) {
          return bodyData(context, productController.state);
        },
      ),
    );
  }

  Widget bodyData(BuildContext context, ProductState state) {
    var productController = context.watch<ProductController>();
    var categories = productController.listCategory ?? [];

    switch (state) {
      case ProductState.success:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategorySelection(
                categories: categories,
                onCategorySelected: (categoryId) {
                  productController.filterProductsByCategoryId(categoryId);
                },
              ),
              24.0.height,
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: productController.filteredProducts?.length,
                  itemBuilder: (context, index) {
                    final product = productController.filteredProducts![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/productDetail',
                            arguments: product.id,
                          );
                        },
                        child: Stack(
                          children: [
                            Card(
                              elevation: 2,
                              color: Colors.white,
                              shadowColor: AppColors.grey,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                side: BorderSide(
                                  color: AppColors.white,
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.network(
                                      product.url!,
                                      fit: BoxFit.contain,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                    ),
                                  ),
                                  16.0.height,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                        4.0.height,
                                        Text(
                                          '\$${product.price.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                icon: Icon(
                                  product.isFavorite!
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.isFavorite!
                                      ? AppColors.red
                                      : AppColors.grey,
                                ),
                                onPressed: () {
                                  if (product.isFavorite!) {
                                    productController.removeFavorite(
                                        context, product.id!);
                                  } else {
                                    productController.addFavorite(
                                        context, product.id!);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      case ProductState.nodata:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CategorySelection(
                  categories: categories,
                  onCategorySelected: (categoryId) {
                    productController.filterProductsByCategoryId(categoryId);
                  },
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'No Data Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case ProductState.error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: CategorySelection(
                  categories: categories,
                  onCategorySelected: (categoryId) {
                    productController.filterProductsByCategoryId(categoryId);
                  },
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Error fetching products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
}
