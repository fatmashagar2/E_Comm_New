import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // استيراد الحزمة
import '../../../layout/layout_cubit/layout_cubit.dart';
import '../../../layout/layout_cubit/layout_states.dart';
import '../../../shared/style/colors.dart';
import '../change_password_screen.dart';
import '../update_user_data_screen.dart';
import 'dart:io'; // لاستعمال File لتحميل الصورة

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image; // متغير لتخزين الصورة المختارة

  final ImagePicker _picker = ImagePicker();

  // دالة لاختيار صورة من المعرض أو الكاميرا
  Future<void> _pickImage() async {
    // عرض مربع حوار لاختيار مصدر الصورة (كاميرا أو معرض)
    final XFile? pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an option"),
          actions: [
            TextButton(
              onPressed: () async {
                final XFile? file = await _picker.pickImage(source: ImageSource.camera); // اختيار الكاميرا
                Navigator.pop(context, file);
              },
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                final XFile? file = await _picker.pickImage(source: ImageSource.gallery); // اختيار المعرض
                Navigator.pop(context, file);
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );

    // التحقق إذا تم اختيار صورة
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // تعيين الصورة المختارة
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = BlocProvider.of<LayoutCubit>(context);
        if (cubit.userModel == null) cubit.getUserData();

        return Scaffold(
          backgroundColor: fifthColor,
          body: cubit.userModel != null
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Center(
              child: Column(
                children: [
                  // صورة الملف الشخصي مع الظل
                  GestureDetector(
                    onTap: _pickImage, // عند الضغط على الصورة لاختيار صورة جديدة
                    child: CircleAvatar(
                      backgroundImage: _image != null
                          ? FileImage(_image!) // استخدام الصورة المختارة
                          : NetworkImage(cubit.userModel!.image!) as ImageProvider, // استخدام الصورة من الإنترنت إذا لم يتم اختيار صورة
                      radius: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // اسم المستخدم مع تنسيق النص
                  Text(
                    cubit.userModel!.name!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // البريد الإلكتروني مع تنسيق النص
                  Text(
                    cubit.userModel!.email!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // أزرار التفاعل
                  _buildButton(
                    context,
                    label: "Change Password",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    context,
                    label: "Update Data",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateUserDataScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  // دالة لبناء الأزرار بشكل موحد
  Widget _buildButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      color: mainColor,
      textColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
