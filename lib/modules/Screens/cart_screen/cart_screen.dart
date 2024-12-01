import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../layout/layout_cubit/layout_cubit.dart';
import '../../../layout/layout_cubit/layout_states.dart';
import '../../../shared/style/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);

    return Scaffold(
      backgroundColor: fifthColor,
      body: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {
          // يمكنك هنا إضافة رد فعل للحالات مثل إضافة أو إزالة عنصر
        },
        builder: (context, state) {
          // حساب إجمالي السعر بناءً على العناصر الموجودة في العربة
          double totalPrice = 0.0;
          for (var cartItem in cubit.carts) {
            totalPrice += cartItem.price!;
          }

          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 10.h),
            child: Column(
              children: [
                Expanded(
                  child: cubit.carts.isNotEmpty
                      ? ListView.separated(
                    itemCount: cubit.carts.length,
                    separatorBuilder: (context, index) {
                      return  SizedBox(height: 12.h);
                    },
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 30,
                        margin:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cubit.carts[index].image!,
                                  fit: BoxFit.fill,
                                  height: 100.h,
                                  width: 100.w,
                                ),
                              ),
                               SizedBox(width: 12.5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cubit.carts[index].name!,
                                      style: TextStyle(
                                        color: mainColor,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                     SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Text("${cubit.carts[index].price!} \$"),
                                         SizedBox(width: 5.w),
                                        if (cubit.carts[index].price != cubit.carts[index].oldPrice)
                                          Text(
                                            "${cubit.carts[index].oldPrice!} \$",
                                            style:  TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.sp,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                      ],
                                    ),
                                     SizedBox(height: 10.h),
                                    MaterialButton(
                                      onPressed: () {
                                        cubit.addOrRemoveFromCart(productID: cubit.carts[index].id.toString());
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
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : const Center(child: Text('Your cart is empty')),
                ),
                // عرض إجمالي السعر
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 20.0.h),
                  child: Container(
                    padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          "Total Price",
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$totalPrice \$",
                          style: TextStyle(fontSize: 18.sp, color: mainColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
