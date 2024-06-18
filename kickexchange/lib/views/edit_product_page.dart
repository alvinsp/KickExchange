import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/widgets/appbar.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductController>().getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: bodyData(context, context.watch<ProductController>().state));
  }

  Widget bodyData(BuildContext context, ProductState state) {
    switch (state) {
      case ProductState.success:
        var dataResult = context.watch<ProductController>().listProduct;
        return Padding(
          padding: const EdgeInsets.only(top: 32),
          child: ListView.builder(
            itemCount: dataResult!.length,
            itemBuilder: (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
                          dataResult[index].url!,
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
                              dataResult[index].name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '\$${dataResult[index].price.toString()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 90,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/productForm',
                                  arguments: dataResult[index].id,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.green,
                                iconColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "CONFIRM DELETE PRODUCT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 24,
                                            color: AppColors.black),
                                      ),
                                      content: Text(
                                        "Are you sure want to delete it?",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.white),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: AppColors.orange,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.orange,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            context
                                                .read<ProductController>()
                                                .deleteProduct(context,
                                                    dataResult[index].id ?? 0);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                padding: EdgeInsets.all(16.0),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Text(
                                                  'Item deleted',
                                                  style: TextStyle(
                                                      color: AppColors.white),
                                                ),
                                                duration: Duration(seconds: 3),
                                                backgroundColor:
                                                    AppColors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0)),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                iconColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      case ProductState.nodata:
        return const Center(
          child: Text('No Data Products'),
        );
      case ProductState.error:
        return Center(
          child: Text(context.watch<ProductController>().messageError),
        );
      default:
        return Center(
          child: const CircularProgressIndicator(),
        );
    }
  }
}
