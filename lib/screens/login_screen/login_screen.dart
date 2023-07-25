import 'dart:convert';

import 'package:school/components/custom_buttons.dart';
import 'package:school/constants.dart';
import 'package:school/models/Student.dart';
import 'package:school/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/LoginRes.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //validate our form now
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailtxt = TextEditingController();
  TextEditingController passtxt = TextEditingController();

  //changes current state
  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //when user taps anywhere on the screen, keyboard hides
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: 100.w,
              height: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('Sign in to continue',
                          style: Theme.of(context).textTheme.titleSmall),
                      sizedBox,
                    ],
                  ),
                  Image.asset(
                    'assets/images/splash.png',
                    height: 20.h,
                    width: 40.w,
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                decoration: BoxDecoration(
                  color: kOtherColor,
                  //reusable radius,
                  borderRadius: kTopBorderRadius,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sizedBox,
                        buildEmailField(),
                        sizedBox,
                        buildPasswordField(),
                        sizedBox,
                        DefaultButton(
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              submitData();
                            }
                          },
                          title: 'SIGN IN',
                          iconData: Icons.arrow_forward_outlined,
                        ),
                        sizedBox,
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Forgot Password',
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: kInputTextStyle,
      decoration: const InputDecoration(
        labelText: 'User',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      controller: emailtxt,
      validator: (value) {
        //for validation
        RegExp regExp = new RegExp(emailPattern);
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
          //if it does not matches the pattern, like
          //it not contains @
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: kInputTextStyle,
      controller: passtxt,
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_off_outlined,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      validator: (value) {
        if (value!.length < 5) {
          return 'Must be more than 5 characters';
        }
      },
    );
  }

  Future submitData() async {
    final email = emailtxt.text;
    final password = passtxt.text;
    final body = {"username": email, "password": password};
    final uri = Uri.parse('http://10.0.2.2:8080/auth/login');
    final res = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    // print(res.statusCode);
    if (res.statusCode == 200) {
      const storage = FlutterSecureStorage();
      // print(jsonDecode(res.body));
      LoginRes loginres = LoginRes.fromJson(jsonDecode(res.body));
      storage.write(key: 'token', value: loginres.token);
      storage.write(key: 'refreshToken', value: loginres.refreshToken);
      storage.write(key: 'roles', value: loginres.roles);
      storage.write(key: 'uid', value: loginres.uid.toString());
      storage.write(key: 'id', value: loginres.id.toString());
      // const storage = FlutterSecureStorage();
      // final id = await storage.read(key: 'id');
      // final token = await storage.read(key: 'token');
      // final uri = Uri.parse('http://10.0.2.2:8080/api/student/' + id.toString());
      // final resp = await http.post(uri, headers: {
      //   'Content-Type': 'application/json',
      //   'Authorization': 'Bearer $token'
      // });
      // if (resp.statusCode == 200) {
      //   String list = jsonEncode(resp.body);
      //   Student student = Student.fromMap(list);
      //   storage.write(key: 'name', value: student.name);

      //   setState(() {});
      // }
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text(
                "Wrong username or password",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
