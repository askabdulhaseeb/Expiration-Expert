import 'dart:io';

import 'package:expiration_expert_admin/database/auth.dart';
import 'package:expiration_expert_admin/database/user_firebase_api.dart';
import 'package:expiration_expert_admin/model/app_user.dart';
import 'package:expiration_expert_admin/screens/home_screen/home_screen.dart';
import 'package:expiration_expert_admin/screens/widgets/custom_textformfield.dart';
import 'package:expiration_expert_admin/screens/widgets/show_loading.dart';
import 'package:expiration_expert_admin/utilities/custom_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utilities/utilities.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({Key? key}) : super(key: key);
  static const String routeName = '/AddAdminScreen';
  @override
  _AddAdminScreenState createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  XFile? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 10),
              _pickImageWidget(),
              const SizedBox(height: 30),
              CustomTextFormField(
                title: 'Name',
                controller: _name,
                validator: (String? value) => CustomValidator.lessThen3(value),
              ),
              CustomTextFormField(
                title: 'Email',
                hint: 'test@test.com',
                controller: _email,
                validator: (String? value) => CustomValidator.email(value),
              ),
              CustomTextFormField(
                title: 'Password',
                isPassword: true,
                controller: _password,
                validator: (String? value) => CustomValidator.password(value),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_key.currentState!.validate()) {
                    showLoadingDislog(context);
                    User? _user = await AuthMethod().signupWithEmailAndPassword(
                        email: _email.text, password: _password.text);
                    if (_user != null) {
                      String? url = '';
                      if (_image != null) {
                        url = await UserFirebaseAPI().uploadImage(
                          File(_image!.path),
                          _user.uid,
                        );
                      }
                      AppUser appUser = AppUser(
                        uid: _user.uid,
                        email: _email.text,
                        displayName: _name.text,
                        imageURL: url ?? '',
                        type: 'admin',
                      );
                      await UserFirebaseAPI().addUser(user: appUser);
                      if (!mounted) return;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName,
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              SizedBox(height: MediaQuery.of(context).size.width / 2),
            ],
          ),
        ),
      ),
    );
  }

  Row _pickImageWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          child: _image != null
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 120,
                  height: 120,
                  child: Image.file(
                    File(_image!.path),
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 120,
                  height: 120,
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[800],
                  ),
                ),
        ),
        TextButton(
          onPressed: () {
            _showPicker(context);
          },
          child: const Text('Choose image'),
        ),
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _file = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = _file;
    });
  }

  Future<void> _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = _file;
    });
  }
}
