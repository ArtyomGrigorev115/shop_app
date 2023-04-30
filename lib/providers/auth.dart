import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

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

  Future<void> signup(String email, String password) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDQPViQYT2v8Qpakgwr5H36H2HfxRBHWTM');

    final response = await http.post(
      url,
      body: json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true},
      ),
    );
    print('Auth ответ: ${json.decode(response.body)}');
  }
}
