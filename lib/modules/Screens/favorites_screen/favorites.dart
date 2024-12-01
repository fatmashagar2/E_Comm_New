import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../layout/layout_cubit/layout_cubit.dart';
import '../../../layout/layout_cubit/layout_states.dart';
import '../../../models/product_model.dart';
import '../../../shared/style/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: fifthColor,
          body: Padding(
            padding:  EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.5.w),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة
                mainAxisSpacing: 10.h, // المسافة بين العناصر رأسيًا
                crossAxisSpacing: 10.w, // المسافة بين العناصر أفقيًا
                childAspectRatio: 1.w / 1.6.h, // نسبة العرض إلى الارتفاع
              ),
              itemCount: cubit.favorites.length,
              itemBuilder: (context, index) {
                final item = cubit.favorites[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 30,
                  margin:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              item.image!,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                         SizedBox(height: 5.h),
                        Text(
                          item.name!,
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                         SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${item.price!}\$ ",
                                      style:  TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Playfair_Display',
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "${item.oldPrice!}\$",
                                      style:  TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                        fontFamily: 'Playfair_Display',
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 10.h),
                        MaterialButton(
                          onPressed: () {
                            cubit.addOrRemoveFromFavorites(productID: item.id.toString());
                          },
                          color: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            "Remove",
                            style: TextStyle(color: Colors.white),
                          ),
                          minWidth: double.infinity,
                          height: 35.h,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
