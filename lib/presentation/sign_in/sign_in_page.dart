import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/domain/auth/auth_repository.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obsecureText = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  Dio _dio = Dio();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SIGN IN',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                validator: (email) {
                  RegExp regex = RegExp(r'\w+@\w+\.\w+');
                  if (email!.isEmpty)
                    return 'We need an email address';
                  else if (!regex.hasMatch(email))
                    // 3
                    return 'That doesn\'t look like an email address';
                  else
                    // 4
                    return null;
                },
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Username'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passController,
                validator: (password) {
                  // 1
                  RegExp hasUpper = RegExp(r'[A-Z]');
                  RegExp hasLower = RegExp(r'[a-z]');
                  RegExp hasDigit = RegExp(r'\d');
                  RegExp hasPunct = RegExp(r'[!@#\$&*~-]');
                  // 2
                  if (!RegExp(r'.{8,}').hasMatch(password!))
                    return 'Passwords must have at least 8 characters';
                  // 3
                  if (!hasUpper.hasMatch(password))
                    return 'Passwords must have at least one uppercase character';
                  // 4
                  if (!hasLower.hasMatch(password))
                    return 'Passwords must have at least one lowercase character';
                  // 5
                  if (!hasDigit.hasMatch(password))
                    return 'Passwords must have at least one number';
                  // 6
                  if (!hasPunct.hasMatch(password))
                    return 'Passwords need at least one special character like !@#\$&*~-';

                  return null;
                },
                obscureText: _obsecureText,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_open),
                    hintText: 'Password',
                    suffixIcon: InkWell(
                      child: Icon(_obsecureText
                          ? Icons.remove_red_eye
                          : Icons.visibility_off),
                      onTap: () {
                        this.setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                    )),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Register here',
                    style: TextStyle(
                        color: Colors.purple[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: 150,
                height: 50,
                child: FlatButton(
                    onPressed: () async {
                      try {
                        await _validateAuthentication();
                      } on Exception catch (message) {
                        print('${message}');
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: Text('Error'),
                            children: [
                              Text(
                                message.toString(),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                    color: Colors.black87,
                    splashColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _validateAuthentication() async {
    if (_formKey.currentState!.validate()) {
      AuthRepository authRepository = AuthRepository();
      await authRepository.signInUser(email: _usernameController.text, password: _passController.text);
      
    } else {
      this.setState(() {
        _autoValidate = true;
      });
    }
  }
}
