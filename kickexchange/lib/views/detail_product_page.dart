import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/core/extensions/sized_box_extension.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:provider/provider.dart';

class DetailProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int productId = ModalRoute.of(context)!.settings.arguments as int;
    final productController = context.watch<ProductController>();
    final product = productController.getProductById(productId);

    return Scaffold(
      appBar: CustomAppBar(),
      body: product != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    height: 320,
                    child: Card(
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        side: BorderSide(
                            color: AppColors.orange,
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignInside),
                      ),
                      child: Image.network(
                        "${product.url}",
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ),
                  24.0.height,
                  Text(
                    "${product.name}",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
                  ),
                  16.0.height,
                  Row(
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 32),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Container(
                        width: 28,
                        child: Divider(
                          color: AppColors.orange,
                          thickness: 2.0,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Seller: ${product.createdBy}",
                        style: TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  16.0.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.card_giftcard),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "${product.qty} pcs",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
            )
          : Center(child: Text('Product not found')),
    );
  }
}
