import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart'; // تأكد من استيراد الحزمة هنا
import 'package:untitled15/shared/constants/constants.dart';
import 'package:untitled15/shared/network/local_network.dart';
import 'layout/layout_cubit/layout_cubit.dart';
import 'layout/layout_screen.dart';
import 'modules/Screens/auth_screens/auth_cubit/auth_cubit.dart';
import 'modules/Screens/auth_screens/login_screen.dart';
import 'shared/bloc_observer/bloc_observer.dart';
import 'dart:io'; // لاستعمال File في حفظ الصورة

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
  final appDocumentDir = await getApplicationDocumentsDirectory(); // تأكد من استخدام هذه الدالة بعد استيراد الحزمة
  Hive.init(appDocumentDir.path);

  // فتح الـ box الخاص بالصور أو البيانات التي تريد تخزينها
  await Hive.openBox<String>('imageBox'); // يمكنك تغيير 'imageBox' إلى اسم الـ box الذي تود استخدامه

  runApp(const MyApp());
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: userToken != null ? const LayoutScreen() : LoginScreen(),
      ),
    );
  }
}
