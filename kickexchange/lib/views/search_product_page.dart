import 'package:flutter/material.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../controllers/product_controller.dart';

class SearchProductPage extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productController = Provider.of<ProductController>(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 32.0, bottom: 32, left: 16, right: 16),
            child: TextField(
              onChanged: (_) {
                final query = _searchController.text;
                if (query.isNotEmpty) {
                  productController.searchProducts(query);
                }
              },
              onSubmitted: (_) {
                final query = _searchController.text;
                if (query.isNotEmpty) {
                  productController.searchProducts(query);
                }
              },
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.orange, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.orange, width: 2),
                ),
                hintText: 'Search Product',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductController>(
              builder: (context, productController, _) {
                if (productController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (productController.messageError.isNotEmpty) {
                  return const Center(
                    child: Text(
                      "No Products Found",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  );
                } else if (productController.listProduct == null ||
                    productController.listProduct!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Products Found',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: productController.listProduct!.length,
                    itemBuilder: (context, index) {
                      final product = productController.listProduct![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: ListTile(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/productDetail',
                            arguments: product.id,
                          ),
                          tileColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              side: BorderSide(
                                  color: AppColors.grey,
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignInside)),
                          title: Text(
                            product.name ?? '',
                            style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'Price: \$${product.price}',
                          ),
                          leading: Image.network(
                            "${product.url}",
                            height: 64,
                            width: 64,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
