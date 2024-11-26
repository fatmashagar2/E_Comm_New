import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled15/modules/Screens/profile_screen/profile_screen.dart';
import '../shared/style/colors.dart';
import 'layout_cubit/layout_cubit.dart';
import 'layout_cubit/layout_states.dart';

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
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                  },
                  child: Image.asset('assets/images/profile.gif')

              )
            ],
            backgroundColor: fifthColor,
            elevation: 0,
            title: Image.asset(
              "assets/images/img2.gif",
              height: 50,
              width: 50,

            ),
          ),
          body: cubit.layoutScreens[cubit.bottomNavIndex],
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: GNav(
              gap: 8,
              activeColor: mainColor,
              color: Colors.grey,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 300),
              tabBackgroundColor: thirdColor,
              onTabChange: (index) {
                cubit.changeBottomNavIndex(index: index);
              },
              selectedIndex: cubit.bottomNavIndex,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: Icons.favorite,
                  text: "Favorites",
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: "Cart",
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
