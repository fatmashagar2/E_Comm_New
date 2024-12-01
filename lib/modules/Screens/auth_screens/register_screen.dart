import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive/rive.dart';
import 'package:untitled15/main.dart';
import '../../../layout/layout_screen.dart';
import 'auth_cubit/animation_enum.dart';
import 'auth_cubit/auth_cubit.dart';
import 'auth_cubit/auth_states.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  // Load Rive animation from assets
  Future<void> loadRiveFileWithItsStates() async {
    final data = await rootBundle.load('assets/login_animation.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    // Add the controller for the idle animation
    artboard.addController(controllerIdle);

    setState(() {
      riveArtboard = artboard;
    });
  }

  // Validate form and register user
  void validateFormAndRegister(AuthCubit authCubit) {
    if (formKey.currentState!.validate()) {
      authCubit.register(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );
    } else {
      if (riveArtboard != null) {
        // Play fail animation when form is invalid
        riveArtboard?.artboard.addController(controllerFail);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    loadRiveFileWithItsStates();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }

  // Check if phone number is valid Egyptian number (10 digits)
  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    final phonePattern = r"^(010|011|012|015)[0-9]{8}$";
    final regExp = RegExp(phonePattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid phone number. It should start with 010, 011, 012, or 015 and contain 10 digits.";
    }
    return null;
  }

  // Check if email is valid and not already used
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email address";
    } else if (!value.contains('@gmail.com')) {
      return "Please enter a valid email address (must be @gmail.com)";
    }
    // Assuming email existence check is done in the API or backend
    return null;
  }

  // Check if password is valid (at least 6 characters)
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 15.w,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.h,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(artboard: riveArtboard!),
              ),
              BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {
                  if (state is RegisterSuccessState) {
                    if (riveArtboard != null) {
                      riveArtboard?.artboard.addController(controllerSuccess);
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LayoutScreen()),
                    );
                  } else if (state is FailedToRegisterState) {
                    if (riveArtboard != null) {
                      riveArtboard?.artboard.addController(controllerFail);
                    }
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: emailValidator,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.phone, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: phoneValidator,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                  if (riveArtboard != null) {
                                    // Play animation when password visibility changes
                                    riveArtboard?.artboard.addController(controllerHandsUp);
                                  }
                                });
                              },
                            ),
                          ),
                          validator: passwordValidator,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 8.w,
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding:  EdgeInsets.symmetric(vertical: 18.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              validateFormAndRegister(authCubit);
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontFamily: 'Sevillana',
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? '),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
