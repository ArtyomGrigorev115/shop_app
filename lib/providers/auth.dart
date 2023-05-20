import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/*
* AIzaSyDQPViQYT2v8Qpakgwr5H36H2HfxRBHWTM
* */

class Auth with ChangeNotifier {
  /*Токен Firebase*/
  String? _token;

  /*Время действи токена*/
  DateTime? _expiryDate;

  /*идентификатор залогиненого пользователя*/
  String? _userId;

   Timer? _authTimer;

  /*пользователь аутентифицирован?
  * если есть токен и  срок действия токена не истёк,
  * тогда пользователь утентифицирован*/
  bool get isAuth{
      return token != null;
  }

  String? get token{
    if(_expiryDate != null && _token != null){
      if(_expiryDate!.isAfter(DateTime.now())){
        return _token!;
      }
    }
    return null;
  }

  String get userId{
    return _userId!;
  }

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
      /*из ответа сервера вытаскиеваем токен, userId, время действия токена */
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();

      notifyListeners();

      /*храним ключ => значение в shared preferences*/
      final prefs = await SharedPreferences.getInstance();
      final String userData =  json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate':_expiryDate?.toIso8601String(),});
      prefs.setString('userData', userData);
      print('AUTHENTIFICATE $prefs');

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

  Future<bool> tryAutologin() async{
    print('метод tryToLogin');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('НЕТ ШАРЕДА');
      return false;
    }
    print('ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ1111111111111111');
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, Object>;
    print('tryToLogIn() extractedUserData $extractedUserData');
    final expiryDate = DateTime.parse(extractedUserData['expiryDate'] as String);
    print('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ');
    if (expiryDate.isBefore(DateTime.now())) {

      return false;
    }
    print('ЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫЫ222222222222222222222222');
    _token = extractedUserData['token'] as String?;
    _userId = extractedUserData['userId'] as String?;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }


  //логаут метод
void logout(){
    _token = null;
    _userId = '';
    _expiryDate = DateTime.now().subtract(const Duration(seconds: 31536000));
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    print('автовыход');
    notifyListeners();
}

/*Автовыход по таймеру*/
void _autoLogout(){
  if(_authTimer != null){
    _authTimer!.cancel();
  }

   final timeToExpiry =  _expiryDate?.difference(DateTime.now()).inSeconds;
   _authTimer =  Timer(Duration(seconds: timeToExpiry!),  logout);
}
}
