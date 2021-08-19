import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../database/auth.dart';
import '../home_screen/home_screen.dart';
import '../widgets/copyrights.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/show_loading.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/images.dart';
import '../../utilities/utilities.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.all(Utilities.padding),
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.16),
              Image.asset(CustomImages.appLogo),
              CustomTextFormField(
                title: 'Email',
                controller: _email,
                hint: 'test@test.com',
                validator: (String? value) => CustomValidator.email(value),
              ),
              CustomTextFormField(
                title: 'Password',
                controller: _password,
                isPassword: true,
                validator: (String? value) => CustomValidator.password(value),
              ),
              const SizedBox(height: 10),
              CustomInkWellButton(
                onTap: () async {
                  if (_key.currentState!.validate()) {
                    showLoadingDislog(context);
                    final User? _user = await AuthMethod()
                        .loginWithEmailAndPassword(_email.text, _password.text);
                    if (_user != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName,
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, letterSpacing: 1),
                ),
              ),
              const Spacer(),
              Copyrights(),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
