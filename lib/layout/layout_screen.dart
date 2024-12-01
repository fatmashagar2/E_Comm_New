import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled15/main.dart';
import 'package:untitled15/modules/Screens/auth_screens/login_screen.dart';
import 'package:untitled15/modules/Screens/profile_screen/profile_screen.dart';
import '../shared/style/colors.dart';
import 'layout_cubit/layout_cubit.dart';
import 'layout_cubit/layout_states.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: fifthColor,
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () async {
                  // مسح بيانات المستخدم من SharedPreferences أو Hive أو أي مكان آخر تم تخزين البيانات فيه
                  // إذا كنت تستخدم SharedPreferences:
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('userToken'); // أو أي مفتاح تستخدمه لحفظ التوكن أو البيانات الخاصة بالمستخدم

                  // إذا كنت تستخدم Hive:
                  var box = await Hive.openBox('userBox');
                  await box.clear(); // مسح جميع البيانات المخزنة في الـ box

                  // بعد مسح البيانات، يمكنك الانتقال إلى شاشة تسجيل الدخول
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Image.asset(
                    'assets/images/exit.png',
                    width: 48.w,
                    height: 48.h,
                  ),
                ),
              ),

            ],
            backgroundColor: fifthColor,
            elevation: 0,
            title: Image.asset(
              "assets/images/img2.gif",
              height: 50.h,
              width: 50.w,
            ),
          ),
          body: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {

              // إذا كان لا يوجد اتصال
              if (snapshot.hasData && snapshot.data == ConnectivityResult.none||snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  backgroundColor: Color(0xffFBF8FB),
                  body: Center(

                    child: Image.asset(
                      "assets/images/noo_connection.gif",

                    ),
                  ),
                );
              }

              // إذا كان هناك اتصال
              if (snapshot.hasData && snapshot.data != ConnectivityResult.none) {
                return cubit.layoutScreens[cubit.bottomNavIndex];
              }

              // في حال لم يتم الحصول على بيانات من الاتصال
              return Center(child: Text('خطأ في الحصول على حالة الاتصال'));
            },
          ),
          bottomNavigationBar: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 10.h),
            child: GNav(
              gap: 8.w,
              activeColor: mainColor,
              color: Colors.grey,
              iconSize: 24.w,/////////////////////////////
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              duration: Duration(milliseconds: 300),
              tabBackgroundColor: thirdColor,
              onTabChange: (index) {
                cubit.changeBottomNavIndex(index: index);
              },
              selectedIndex: cubit.bottomNavIndex,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.favorite,
                  text: "Favorites",
                  iconColor: cubit.favoriteItemCount > 0 ? mainColor : Colors.grey,
                  leading: cubit.favoriteItemCount > 0
                      ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: cubit.favoriteItemCount > 0 ? mainColor : Colors.grey,
                      ),
                      Positioned(
                        right: -5.w,
                        top: -8.h,
                        child: Text(
                          '${cubit.favoriteItemCount}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                      : null,
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: "Cart",
                  iconColor: cubit.cartItemCount > 0 ? mainColor : Colors.grey,
                  leading: cubit.cartItemCount > 0
                      ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: cubit.cartItemCount > 0 ? mainColor : Colors.grey,
                      ),
                      Positioned(
                        right: -5.w,
                        top: -8.h,
                        child: Text(
                          '${cubit.cartItemCount}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                      : null,
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}