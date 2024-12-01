import 'dart:convert';
import 'package:bloc/bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../../shared/constants/constants.dart';
import '../../../../shared/network/local_network.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit() : super(AuthInitialState());

  // Todo: API URL => https://student.valuxapps.com/api/
  // Todo: Register endpoint => register
  void register({required String email, required String name,
    required String phone, required String password}) async {
    emit(RegisterLoadingState());

    try {
      // إرسال طلب التسجيل مباشرة إلى الـ API بدون التحقق من وجود الرقم مسبقًا.
      Response response = await http.post(
        Uri.parse('https://student.valuxapps.com/api/register'),
        body: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'image': "jdfjfj",  // الصورة الثابتة هنا
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == true) {
          await CacheNetwork.insertToCache(key: "token", value: data['data']['token']);
          await CacheNetwork.insertToCache(key: "password", value: password);
          userToken = await CacheNetwork.getCacheData(key: "token");
          currentPassword = await CacheNetwork.getCacheData(key: "password");
          emit(RegisterSuccessState());
        } else {
          debugPrint("Failed to register, reason: ${data['message']}");
          emit(FailedToRegisterState(message: data['message']));
        }
      } else {
        debugPrint("Failed to register, reason: ${response.body}");
        emit(FailedToRegisterState(message: "Failed to register, try again later."));
      }
    } catch (e) {
      debugPrint("Error during registration: $e");
      emit(FailedToRegisterState(message: e.toString()));
    }
  }



  // Account : mo.ha@gmail.com , password : 123456
  void login({required String email,required String password}) async {
    emit(LoginLoadingState());
    try{
      Response response = await http.post(
        // request => url = base url + method url
        Uri.parse('https://student.valuxapps.com/api/login'),
        body: {
          'email' : email,
          'password' : password
        },
      );
      if( response.statusCode == 200 )
        {
          var responseData = jsonDecode(response.body);
          if( responseData['status'] == true )
            {
              // debugPrint("User login success and his Data is : ${responseData['data']['token']}");
              await CacheNetwork.insertToCache(key: "token", value: responseData['data']['token']);
              await CacheNetwork.insertToCache(key: "password", value: password);
              userToken = await CacheNetwork.getCacheData(key: "token");
              currentPassword = await CacheNetwork.getCacheData(key: "password");
              emit(LoginSuccessState());
            }
          else
            {
              debugPrint("Failed to login, reason is : ${responseData['message']}");
              emit(FailedToLoginState(message: responseData['message']));
            }
        }
    }
    catch(e){
      emit(FailedToLoginState(message: e.toString()));
    }
  }

  String? chosenValue;
  void changeDropDownValue({required String val})
  {
    chosenValue = val;
    emit(ChangeValueSuccessState());
  }
}


