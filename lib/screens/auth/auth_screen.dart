import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/components/my_button.dart';
import 'package:wwjd_chat/model/user.dart';
import 'package:wwjd_chat/util/color.dart';
import 'package:wwjd_chat/util/util.dart';

import '../../data_source/remote/api_service.dart';
import '../../components/my_passwordField.dart';
import '../../components/my_textfield.dart';
import '../../data_source/local/secure_storage.dart';
import '../../util/constant.dart';
import '../chat/chat_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _fName = '';
  var _lName = '';
  var _email = '';
  var _phone = '';
  var _password = '';
  bool _isLoginPage = true;
  late final ApiService _apiService;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.reset();
  }

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey[400],
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // logo
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/WWJD-dark.png"),
                backgroundColor: primaryColor,
                radius: 50,
              ),
              const SizedBox(height: 50),

              // welcome back, you've been missed!
              Text(
                _isLoginPage
                    ? 'Sign-in to Continue to WWJDchat.'
                    : 'Get your free WWJDchat account now.',
                style: GoogleFonts.roboto(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      // full name textfield
                      if (!_isLoginPage)
                        MyTextFormField(
                          key: const ValueKey("fName"),
                          hintText: 'Enter full name',
                          obscureText: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter your Full Name.";
                            }
                            return null;
                          },
                          onSave: (newValue) {
                            _fName = newValue.substring(0, newValue.indexOf(
                                " "));
                            _lName = newValue.substring(newValue.indexOf(" ") +
                                1);
                          },
                          keyboardType: TextInputType.name,
                        ),

                      const SizedBox(height: 10),

                      // email textfield
                      MyTextFormField(
                        key: const ValueKey("email"),
                        hintText: 'Enter email',
                        obscureText: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter your Email.";
                          } else if (!EmailValidator.validate(value)) {
                            return "Please Enter a Valid Email";
                          }
                          return null;
                        },
                        onSave: (newValue) {
                          _email = newValue;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 10),

                      // phone textfield
                      if (!_isLoginPage)
                        MyTextFormField(
                          key: const ValueKey("phone"),
                          hintText: 'Enter phone',
                          obscureText: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please Enter your Phone number.";
                            }
                            return null;
                          },
                          onSave: (newValue) {
                            _phone = newValue;
                          },
                          keyboardType: TextInputType.phone,
                        ),

                      const SizedBox(height: 10),

                      // password textfield
                      MyPasswordFormField(
                        key: const ValueKey("password"),
                        hintText: 'Enter password',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Password.";
                          }
                          return null;
                        },
                        onSave: (newValue) {
                          _password = newValue;
                        },
                      ),

                      const SizedBox(height: 10),

                      // forgot password?
                      // if(isLoginPage)
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Text(
                      //         'Forgot Password?',
                      //         style: GoogleFonts.roboto(color: Colors.grey[800],decoration: TextDecoration.underline),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 25),

                      // login register button
                      MyButton(
                        onTap: startAuthentication,
                        text: _isLoginPage ? "Login" : "Register",
                        isLoading: _isLoading,
                      ),
                    ],
                  )),

              const SizedBox(height: 50),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLoginPage
                        ? 'Don\'t Have an Account?'
                        : 'Already Have an Account?',
                    style: GoogleFonts.roboto(color: Colors.grey[700]),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginPage = !_isLoginPage;
                        _formKey.currentState?.reset();
                      });
                    },
                    child: Text(
                      _isLoginPage ? 'Sign Up now' : 'Login',
                      style: GoogleFonts.roboto(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //authenticate user input before submit form
  startAuthentication() {
    final validity = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity!) {
      _formKey.currentState?.save();
      submitForm();
    }
  }

  //submit auth form
  submitForm() async {
    setState(() => _isLoading = true);
    if (_isLoginPage) {
      //login request
      if(await Util.isOnline()) {
        _apiService.sendLoginRequest(_email, _password).then((response) {
          if (response.statusCode == 200) {
            //login success message
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "Login Success", style: TextStyle(color: Colors.white),)));
            Map<String, dynamic> responseJson = jsonDecode(response.body);
            String accessToken = responseJson['token']['access'];
            User user = User.fromJson(responseJson['user']);
            print(User.serialize(user));
            // String userId = responseJson['user']['id'].toString();
            // String email = responseJson['user']['email'];
            // String userName = responseJson['user']['first_name'] +
            //     " " +
            //     responseJson['user']['last_name'];
            SecureStorage.getInstance().writeSecureData(
                USER_KEY, User.serialize(user));
            // SecureStorage.getInstance().writeSecureData(USER_EMAIL_KEY, email);
            // SecureStorage.getInstance().writeSecureData(USER_NAME_KEY, userName);
            SecureStorage.getInstance()
                .writeSecureData(ACCESS_TOKEN_KEY, accessToken);
            setState(() => _isLoading = false);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ));
          } else if (response.statusCode == 401) {
            setState(() => _isLoading = false);
            Fluttertoast.showToast(msg: "Invalid username or password");
          } else {
            setState(() => _isLoading = false);
            Fluttertoast.showToast(msg: response.reasonPhrase.toString());
          }
        });
      }else{
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "No Internet connection");
      }
    } else {
      //register request

      if(await Util.isOnline()){
      _apiService
          .sendRegisterRequest(_email, _password, _fName, _lName, _phone)
          .then((response) {
        if (response.statusCode == 200) {
          //register success message
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text("User Created successfully",
                style: TextStyle(color: Colors.white),)));
          setState(() {
            _formKey.currentState?.reset();
            _isLoading = false;
            _isLoginPage = true;
          });
        } else {
          setState(() => _isLoading = false);
          Fluttertoast.showToast(msg: response.reasonPhrase.toString());
        }
      });
      }else{
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: "No Internet connection");
      }
    }
  }

}
