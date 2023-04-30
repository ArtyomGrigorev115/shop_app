import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

/*
* AIzaSyDQPViQYT2v8Qpakgwr5H36H2HfxRBHWTM
* */

class Auth with ChangeNotifier {
  /*Токен Firebase*/
  String? _token;

  /*Время действи токена*/
  DateTime? _expityDate;

  /*идентификатор залогиненого пользователя*/
  String? _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyDQPViQYT2v8Qpakgwr5H36H2HfxRBHWTM');
    try{
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );

      final  responseData = json.decode(response.body);
      if(responseData['error'] != null){
        print('ОШИБКА!!! $responseData');
        throw HttpException(responseData['error']['message']);
      }

      if(urlSegment == 'accounts:signUp'){
        print('регистрация ответ:  $urlSegment  ${json.decode(response.body)}');
      }
      else{
        print('вход ответ:  $urlSegment  ${json.decode(response.body)}');
      }
    }
    catch(error){
      rethrow;
    }




    //print('аутентификация ответ:  что нужно сделать?: $urlSegment  ${json.decode(response.body)}');
  }

  Future<void> signup(String email, String password) async {
    // final Uri url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDQPViQYT2v8Qpakgwr5H36H2HfxRBHWTM');
    //
    // final response = await http.post(
    //   url,
    //   body: json.encode(
    //     {'email': email, 'password': password, 'returnSecureToken': true},
    //   ),
    // );
    // print('регистрация ответ: ${json.decode(response.body)}');

    return _authenticate(email, password, 'accounts:signUp');
  }

  Future<void> login(String email, String password) async {
    // final Uri url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDQPViQYT2v8Qpakgwr5H36H2HfxRBHWTM');
    //
    // final response = await http.post(
    //   url,
    //   body: json.encode(
    //     {'email': email, 'password': password, 'returnSecureToken': true},
    //   ),
    // );
    // print('логин ответ: ${json.decode(response.body)}');
    return _authenticate(email, password, 'accounts:signInWithPassword');
  }
}