import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/models/http_exception.dart';

import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);

    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),

                      //расположение контейнера под углом
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'Всякое',
                        style: TextStyle(
                        //  color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  //Глобальный ключ формы с полями для ввода инф. от пользователя
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  /*Дилог  ошибкой*/
  void _showErrorDialog(String message){
    showDialog(context: context, builder: (builderContext) => AlertDialog(
      title: const Text('Упс! Ошибочка'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(builderContext).pop(),
            child: const Text('Пон'),),
      ],
    ),);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Валидация не пройдена
      print('Невалид');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try{
      if (_authMode == AuthMode.Login) {
        // Логин пользователя
        await Provider.of<Auth>(context, listen: false).login(_authData['email']!, _authData['password']!);
      } else {
        // Регистрация пользователя
        await Provider.of<Auth>(context, listen: false).signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch(error){
      String errorMessage = 'Ошибка!';

     if(error.toString().contains('EMAIL_EXISTS')){
       errorMessage = 'Такой e-mail адрес уже занят';
     }
     else if(error.toString().contains('EMAIL_NOT_FOUND')){
       errorMessage = 'Введён несуществующий e-mail';
     }
     else if(error.toString().contains('INVALID_EMAIL')){
       errorMessage = 'Введён некорректный e-mail';
     }
     else if(error.toString().contains('WEAK_PASSWORD')){
       errorMessage = 'Недостаточно надёжный пароль';
     }
     else if(error.toString().contains('INVALID_PASSWORD')){
       errorMessage = 'Неправильный пароль';
     }
     _showErrorDialog(errorMessage);
    } catch(error){
      const String errorMessage = 'Непредвиденная ошибка. Попробуйте позже';
      _showErrorDialog(errorMessage);
    }


    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Почта'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value!.contains('@')) {
                      return 'Некорректный e-mail';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Короткий пароль';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: const InputDecoration(labelText: 'Подтвердите пароль'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Пароли не совпадают';
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      textStyle: TextStyle(color: Theme.of(context).primaryTextTheme.labelLarge!.color,),
                     // color: Theme.of(context).primaryColor,
                    //  textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                    child:
                        Text(_authMode == AuthMode.Login ? 'Войти' : 'Регистрация'),

                  ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                   // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                   // textColor: Theme.of(context).primaryColor,
                    textStyle: TextStyle(color: Theme.of(context).primaryColor,)
                  ),
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'Регистрация' : 'Войти'} Попробовать'),

                 // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 // textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
