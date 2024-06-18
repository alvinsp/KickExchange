import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:provider/provider.dart';

class FavoriteProductsPage extends StatefulWidget {
  const FavoriteProductsPage({super.key});

  @override
  State<FavoriteProductsPage> createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteProductsPage> {
  @override
  void initState() {
    super.initState();
    final productController = context.read<ProductController>();
    productController.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kick",
              style: TextStyle(
                fontFamily: 'raleway',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
            ),
            Text(
              "Exchange",
              style: TextStyle(
                fontFamily: 'montserrat',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<ProductController>(
        builder: (context, productController, _) {
          if (productController.state == ProductState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (productController.state == ProductState.error) {
            return Center(
              child: Text(
                productController.messageError,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (productController.state == ProductState.nodata) {
            return const Center(
              child: Text("No favorite products found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            );
          } else if (productController.state == ProductState.success) {
            return Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: ListView.builder(
                itemCount: productController.favoriteProducts?.length ?? 0,
                itemBuilder: (context, index) {
                  var product = productController.favoriteProducts![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/productDetail',
                        arguments: product.id,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          side: BorderSide(color: AppColors.orange, width: 2.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: SizedBox(
                                width: 64,
                                child: Image.network(
                                  product.url!,
                                  fit: BoxFit.contain,
                                  height: 64,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '\$${product.price.toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 90,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.favorite,
                                          color: Colors.red),
                                      onPressed: () {
                                        productController.removeFavorite(
                                            context, product.id!);
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
