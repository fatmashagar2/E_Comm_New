import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/layout_cubit/layout_cubit.dart';
import '../../layout/layout_cubit/layout_states.dart';
import '../../shared/style/colors.dart';

class UpdateUserDataScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  UpdateUserDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    nameController.text = cubit.userModel!.name!;
    phoneController.text = cubit.userModel!.phone!;
    emailController.text = cubit.userModel!.email!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Data"),
        backgroundColor: thirdColor,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // User Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "User Name",
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 15),
            // Phone Field
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                hintText: "Enter your phone number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 15),
            // Email Field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            SizedBox(height: 20),
            // Update Button
            BlocConsumer<LayoutCubit, LayoutStates>(
              listener: (context, state) {
                if (state is UpdateUserDataSuccessState) {
                  showSnackBarItem(context, "Data Updated Successfully", true);
                  Navigator.pop(context);
                }
                if (state is UpdateUserDataWithFailureState) {
                  showSnackBarItem(context, state.error, false);
                }
              },
              builder: (context, state) {
                return MaterialButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty &&
                        emailController.text.isNotEmpty) {
                      cubit.updateUserData(
                          name: nameController.text,
                          phone: phoneController.text,
                          email: emailController.text);
                    } else {
                      showSnackBarItem(context, 'Please, Enter all Data !!', false);
                    }
                  },
                  color: mainColor,
                  textColor: Colors.white,
                  height: 50,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    state is UpdateUserDataLoadingState ? "Loading..." : "Update",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBarItem(BuildContext context, String message, bool forSuccessOrFailure) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: forSuccessOrFailure ? Colors.green : Colors.red,
    ));
  }
}
