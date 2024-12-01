import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../layout/layout_cubit/layout_cubit.dart';
import '../../../layout/layout_cubit/layout_states.dart';
import '../../../models/product_model.dart';

class DetailsScreen extends StatelessWidget {
  final ProductModel product;

  DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          product.name!,
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ListView(
          children: [
            // صورة المنتج
            Center(
              child: Image.network(
                product.image!,
                fit: BoxFit.cover,
                width: 250.w, // تصغير الصورة
                height: 250.h, // تصغير الصورة
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              product.name!,
              style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                 ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  "${product.price!}\$ ",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                Text(
                  "${product.oldPrice!}\$",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18.sp,

                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,

              ),
            ),
            SizedBox(height: 10.h),
            Text(
              product.description!,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Playfair_Display',
              ),
            ),
            SizedBox(height: 20.h),
            // الأزرار (إضافة إلى السلة والمفضلة)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة المفضلة
                GestureDetector(
                  onTap: () async {
                    final AudioPlayer audioPlayer = AudioPlayer();
                    try {
                      await audioPlayer.play(AssetSource('sounds/sound2.mp3'));
                    } catch (e) {
                      print("Error playing sound: $e");
                    }
                    // إضافة أو إزالة من المفضلة
                    cubit.addOrRemoveFromFavorites(productID: product.id.toString());
                  },
                  child: BlocBuilder<LayoutCubit, LayoutStates>(
                    builder: (context, state) {
                      return Icon(
                        Icons.favorite,
                        color: cubit.FavoritesIds.contains(product.id.toString())
                            ? Colors.red
                            : Colors.grey,
                        size: 35.sp,
                      );
                    },
                  ),
                ),
                SizedBox(width: 20.w),
                // أيقونة السلة
                GestureDetector(
                  onTap: () async {
                    final AudioPlayer audioPlayer = AudioPlayer();
                    try {
                      await audioPlayer.play(AssetSource('sounds/sound1.mp3'));
                    } catch (e) {
                      print("Error playing sound: $e");
                    }
                    // إضافة أو إزالة من السلة
                    cubit.addOrRemoveFromCart(productID: product.id.toString());
                  },
                  child: BlocBuilder<LayoutCubit, LayoutStates>(
                    builder: (context, state) {
                      return Icon(
                        Icons.shopping_cart,
                        color: cubit.cartIDs.contains(product.id.toString())
                            ? Colors.green
                            : Colors.grey,
                        size: 35.sp,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
