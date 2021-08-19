import 'dart:io';

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
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  XFile? _image;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            // _pickImageWidget(),
            SizedBox(height: 30),
            Text(
              'Remaining Part Will Show When you place you Order',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),
            Text(
              'Thanks :)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            )
          ],
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
