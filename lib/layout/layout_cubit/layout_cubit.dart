import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../models/banner_model.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../modules/Screens/cart_screen/cart_screen.dart';
import '../../modules/Screens/categories_screen/categories_screen.dart';
import '../../modules/Screens/favorites_screen/favorites.dart';
import '../../modules/Screens/home_screen/home_screen.dart';
import '../../modules/Screens/profile_screen/profile_screen.dart';
import '../../shared/constants/constants.dart';
import 'package:flutter/material.dart';
import '../../shared/network/local_network.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  int bottomNavIndex = 0;
  List<Widget> layoutScreens = [
    HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];

  void changeBottomNavIndex({required int index}) {
    bottomNavIndex = index;
    // Emit state
    emit(ChangeBottomNavIndexState());
  }

  UserModel? userModel;

  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/profile"),
        headers: {
          'Authorization': userToken!,
          "lang": "en"
        }
    );
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      userModel = UserModel.fromJson(data: responseData['data']);
      emit(GetUserDataSuccessState());
    } else {
      emit(FailedToGetUserDataState(error: responseData['message']));
    }
  }

  List<BannerModel> banners = [];

  void getBannersData() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/banners")
    );
    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']) {
        banners.add(BannerModel.fromJson(data: item));
      }
      emit(GetBannersSuccessState());
    } else {
      emit(FailedToGetBannersState());
    }
  }

  List<CategoryModel> categories = [];

  void getCategoriesData() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/categories"),
        headers: {
          'lang': "en"
        }
    );
    final responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']['data']) {
        categories.add(CategoryModel.fromJson(data: item));
      }
      emit(GetCategoriesSuccessState());
    } else {
      emit(FailedToGetCategoriesState());
    }
  }

  List<ProductModel> products = [];

  void getProducts() async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/home"),
        headers: {
          'Authorization': userToken!,
          'lang': "en"
        }
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']['products']) {
        products.add(ProductModel.fromJson(data: item));
      }
      emit(GetProductsSuccessState());
    } else {
      emit(FailedToGetProductsState());
    }
  }

  // filtered products
  List<ProductModel> filteredProducts = [];

  void filterProducts({required String input}) {
    filteredProducts = products
        .where((element) => element.name!.toLowerCase().contains(input.toLowerCase()))
        .toList();
    emit(FilterProductsSuccessState());
  }

  List<ProductModel> favorites = [];
  Set<String> favoritesID = {};

  Future<void> getFavorites() async {
    favorites.clear();
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers: {
          "lang": "en",
          "Authorization": userToken!
        }
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']['data']) {
        favorites.add(ProductModel.fromJson(data: item['product']));
        favoritesID.add(item['product']['id'].toString());
      }
      emit(GetFavoritesSuccessState());
    } else {
      emit(FailedToGetFavoritesState());
    }
  }

  int favoriteItemCount = 0;

  Future<void> addOrRemoveFromFavorites({required String productID}) async {
    try {
      // هنا يمكنك تعديل حالة البداية إن كنت تحتاج
      // emit(AddOrRemoveFromFavoritesLoadingState());

      if (userToken == null || userToken!.isEmpty) {
        // حالة في حال عدم وجود توكن المستخدم
        // emit(FailedToAddOrRemoveFromFavoritesState('User token is missing.'));
        return;
      }

      // طلب إضافة أو إزالة المنتج من المفضلة
      Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/favorites"),
        headers: {
          "Authorization": userToken!,
          "lang": "en",
        },
        body: {
          "product_id": productID,
        },
      );

      var responseBody = jsonDecode(response.body);

      if (responseBody['status'] == true) {
        // إضافة أو إزالة المنتج من المفضلة
        if (favorites.any((product) => product.id.toString() == productID)) {
          favorites.removeWhere((product) => product.id.toString() == productID);
        } else {
          ProductModel product = await getProductById(productID); // استرجاع المنتج من خلال الـ ID
          favorites.add(product);
        }

        // تحديث عداد المفضلة
        favoriteItemCount = favorites.length;

        // emit(AddOrRemoveFromFavoritesSuccessState());
      } else {
        // emit(FailedToAddOrRemoveFromFavoritesState(responseBody['message']));
      }
    } catch (e) {
      // التعامل مع الأخطاء
      // emit(FailedToAddOrRemoveFromFavoritesState(e.toString()));
    }
  }


  int totalPrice = 0;

  void getCarts() async {
    carts.clear();
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers: {
          "Authorization": userToken!,
          "lang": "en"
        }
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      for (var item in responseBody['data']['cart_items']) {
        carts.add(ProductModel.fromJson(data: item['product']));
      }
      totalPrice = responseBody['data']['total'];
      emit(GetCartsSuccessState());
    } else {
      emit(FailedToGetCartsState());
    }
  }
  Future<void> addToCart({required String productID}) async {
    emit(AddToCartLoadingState());

    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers: {
          "Authorization": userToken!,
          "lang": "en"
        },
        body: {
          "product_id": productID
        }
    );

    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      ProductModel product = await getProductById(productID);
      carts.add(product);
      totalPrice = responseBody['data']['total'];
      emit(AddToCartSuccessState());
    } else {
      emit(FailedToAddToCartState(responseBody['message']));
    }
  }
  List<String> get cartIDs {
    return carts.map((product) => product.id.toString()).toList();
  }




  List<ProductModel> carts = [];
  int cartItemCount = 0;

  Future<void> addOrRemoveFromCart({required String productID}) async {
    try {
      emit(AddOrRemoveFromCartLoadingState());

      if (userToken == null || userToken!.isEmpty) {
        emit(FailedToAddOrRemoveFromCartState('User token is missing.'));
        return;
      }

      Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/carts"),
        headers: {
          "Authorization": userToken!,
          "lang": "en",
        },
        body: {
          "product_id": productID,
        },
      );

      var responseBody = jsonDecode(response.body);

      if (responseBody['status'] == true) {
        if (carts.any((product) => product.id.toString() == productID)) {
          carts.removeWhere((product) => product.id.toString() == productID);
        } else {
          ProductModel product = await getProductById(productID);
          carts.add(product);
        }

        // Update the cart item count
        cartItemCount = carts.length;

        emit(AddOrRemoveFromCartSuccessState());
      } else {
        emit(FailedToAddOrRemoveFromCartState(responseBody['message']));
      }
    } catch (e) {
      emit(FailedToAddOrRemoveFromCartState(e.toString()));
    }
  }
  Future<ProductModel> getProductById(String productID) async {
    Response response = await http.get(
        Uri.parse("https://student.valuxapps.com/api/products/$productID"),
        headers: {
          "Authorization": userToken!,
          "lang": "en"
        }
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody['status'] == true) {
      return ProductModel.fromJson(data: responseBody['data']);
    } else {
      throw Exception('Failed to load product');
    }
  }

  void changePassword({required String userCurrentPassword, required String newPassword}) async {
    emit(ChangePasswordLoadingState());
    Response response = await http.post(
        Uri.parse("https://student.valuxapps.com/api/change-password"),
        headers: {
          'lang': 'en',
          'Authorization': userToken!
        },
        body: {
          'current_password': userCurrentPassword,
          'new_password': newPassword,
        }
    );
    var responseDecoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseDecoded['status'] == true) {
        await CacheNetwork.insertToCache(key: 'password', value: newPassword);
        currentPassword = await CacheNetwork.getCacheData(key: "password");
        emit(ChangePasswordSuccessState());
      } else {
        emit(ChangePasswordWithFailureState(responseDecoded['message']));
      }
    } else {
      emit(ChangePasswordWithFailureState("something went wrong, try again later"));
    }
  }

  void updateUserData({required String name, required String phone, required String email}) async {
    emit(UpdateUserDataLoadingState());
    try {
      Response response = await http.put(
          Uri.parse("https://student.valuxapps.com/api/update-profile"),
          headers: {
            'lang': 'en',
            'Authorization': userToken!
          },
          body: {
            'name': name,
            'email': email,
            'phone': phone
          }
      );
      var responseBody = jsonDecode(response.body);
      if (responseBody['status'] == true) {
        await getUserData();
        emit(UpdateUserDataSuccessState());
      } else {
        emit(UpdateUserDataWithFailureState(responseBody['message']));
      }
    } catch (e) {
      emit(UpdateUserDataWithFailureState(e.toString()));
    }
  }
}
