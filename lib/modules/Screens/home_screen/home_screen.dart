import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled15/layout/layout_screen.dart';
import '../../../layout/layout_cubit/layout_cubit.dart';
import '../../../layout/layout_cubit/layout_states.dart';
import '../../../models/product_model.dart';
import '../../../shared/style/colors.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);

    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(

          backgroundColor: fifthColor,
          body: Padding(
            padding:  EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 15.w),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.black, width: 2.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                      cubit.filterProducts(input: query);
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: 20.h),
                // Improved Banners Section
                cubit.banners.isEmpty
                    ? const Center(
                  child: CupertinoActivityIndicator(),
                )
                    : CarouselSlider.builder(
                  itemCount: cubit.banners.length,
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.network(
                        cubit.banners[index].url!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 180,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                ),
                 SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Products",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontFamily: 'Sevillana',
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "View all",
                      style: TextStyle(
                          color: secondColor,
                          fontSize: 14.sp,
                          fontFamily: 'Sevillana',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                 SizedBox(height: 15.h),
                cubit.products.isEmpty
                    ? const Center(
                  child: CupertinoActivityIndicator(),
                )
                    : GridView.builder(
                  itemCount: cubit.filteredProducts.isEmpty
                      ? cubit.products.length
                      : cubit.filteredProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                   SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.w,
                      crossAxisSpacing: 15.h,
                      childAspectRatio: 0.7),
                  itemBuilder: (context, index) {
                    return _productItem(
                      model: cubit.filteredProducts.isEmpty
                          ? cubit.products[index]
                          : cubit.filteredProducts[index],
                      cubit: cubit,
                      context: context, // Pass context here
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _productItem({
  required ProductModel model,
  required LayoutCubit cubit,
  required BuildContext context,
}) {
  return Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
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
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                model.image!,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
           SizedBox(height: 5.h),
          Text(
            model.name!,
            style:  TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                overflow: TextOverflow.ellipsis),
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
                        "${model.price!}\$ ",
                        style:  TextStyle(fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Playfair_Display'
                        ),
                      ),
                    ),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "${model.oldPrice!}\$",
                        style:  TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontFamily: 'Playfair_Display',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           SizedBox(height: 10.h),
          // Icons row at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.favorite,
                  size: 20.h,
                  color: cubit.FavoritesIds.contains(model.id.toString())
                      ? Colors.red
                      : Colors.grey,
                ),
                onTap: () async {
                  final AudioPlayer audioPlayer = AudioPlayer();
                  try {
                    await audioPlayer.play(AssetSource('sounds/sound2.mp3'));
                  } catch (e) {
                    print("Error playing sound: $e");
                  }
                  cubit.addOrRemoveFromFavorites(productID: model.id.toString());
                },
              ),
              GestureDetector(
                child: Icon(
                  Icons.shopping_cart,
                  size: 20.h,
                  color: cubit.cartIDs.contains(model.id.toString())
                      ? Colors.green  // إذا كان المنتج في السلة، اجعل اللون أخضر
                      : Colors.grey,  // إذا لم يكن في السلة، اجعل اللون رمادي
                ),
                onTap: () async {
                  // تشغيل الصوت عند الضغط
                  final AudioPlayer audioPlayer = AudioPlayer();
                  try {
                    await audioPlayer.play(AssetSource('sounds/sound1.mp3'));
                  } catch (e) {
                    print("Error playing sound: $e");
                  }

                  // إضافة أو إزالة من العربة بشكل مستقل
                  cubit.addOrRemoveFromCart(productID: model.id.toString());
                },
              ),

            ],
          ),
        ],
      ),
    ),
  );
}
