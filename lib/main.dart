import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled15/modules/Screens/on_boarding/on_boarding_screens.dart';
import 'package:untitled15/shared/constants/constants.dart';
import 'package:untitled15/shared/network/local_network.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'layout/layout_cubit/layout_cubit.dart';
import 'layout/layout_screen.dart';
import 'modules/Screens/auth_screens/auth_cubit/auth_cubit.dart';
import 'modules/Screens/auth_screens/login_screen.dart';
import 'modules/Screens/splash_screen/splash_screen.dart';
import 'shared/bloc_observer/bloc_observer.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Bloc Observer
  Bloc.observer = MyBlocObserver();

  // تهيئة Cache Network
  await CacheNetwork.cacheInitialization();

  // قراءة الـ token وكلمة المرور من Cache
  userToken = await CacheNetwork.getCacheData(key: 'token');
  currentPassword = await CacheNetwork.getCacheData(key: 'password');

  // طباعة الـ token وكلمة المرور للتحقق
  debugPrint("User token is : $userToken");
  debugPrint("Current Password is : $currentPassword");

  // تهيئة Hive
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // فتح الـ box الخاص بالصور أو البيانات التي تريد تخزينها
  await Hive.openBox<String>('imageBox');

  // فتح الـ userBox للتخزين المحلي لبيانات المستخدم
  var userBox = await Hive.openBox('userBox');

  // يمكنك الآن قراءة البيانات من الـ userBox مثلًا:
  var userData = userBox.get('userData'); // استبدل 'userData' بالمفتاح الذي تستخدمه
  debugPrint("User Data: $userData");

  // التحقق من الاتصال بالشبكة
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // في حالة عدم وجود اتصال بالشبكة
    debugPrint("No network connection");
  } else {
    // التحقق من الاتصال بالإنترنت الفعلي
    bool isConnected = await _isInternetConnected();
    if (isConnected) {
      debugPrint("Connected to the internet");
    } else {
      debugPrint("No internet connection");
    }
  }

  runApp(const MyApp());
}

// التحقق من الوصول إلى الإنترنت
Future<bool> _isInternetConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => LayoutCubit()
          ..getCarts()
          ..getFavorites()
          ..getBannersData()
          ..getCategoriesData()
          ..getProducts()
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 640), // حجم التصميم الأساسي (iPhone X كمثال)
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
           //home:LoginScreen()
             home: SplashScreen(), // يمكن تغيير هذه إلى شاشة تسجيل الدخول بناءً على حالة التوكن
          );
        },
      ),
    );
  }
}
