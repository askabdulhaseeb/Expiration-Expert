import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../database/product_firebase_api.dart';
import '../../model/primary_category.dart';
import '../../model/product.dart';
import '../../model/secondary_category.dart';
import '../../providers/primary_category_provider.dart';
import '../home_screen/home_screen.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/show_loading.dart';
import '../../utilities/custom_dropdown.dart';
import '../../utilities/custom_toast.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/utilities.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);
  static const String routeName = '/AddProductScreen';
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _barcode = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _price = TextEditingController();
  XFile? _image;
  File? file;
  @override
  Widget build(BuildContext context) {
    final CategoryProvider provider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Add Product'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8),
              _pickImageWidget(),
              const SizedBox(height: 10),
              CustomTextFormField(
                title: 'Product ID',
                controller: _barcode,
                hint: 'Product Unique ID',
                validator: (String? value) => CustomValidator.lessThen3(value),
              ),
              _selectScanBarcodeWidget(),
              CustomDropdownButton(
                items: provider.primary
                    .map((PrimaryCategory e) => DropdownMenuItem<String>(
                          value: e.id,
                          child: Text(e.title),
                        ))
                    .toList(),
                selectedItem: provider.selectedPri,
                hint: 'Primory Category',
                onChange: (String? value) => provider.onPrimorySelection(value),
              ),
              CustomDropdownButton(
                items: provider
                    .secondory(provider.selectedPri)!
                    .map((SecondaryCategory e) => DropdownMenuItem<String>(
                          value: e.id,
                          child: Text(e.title),
                        ))
                    .toList(),
                selectedItem: provider.selectedSec,
                hint: 'Secondory Category',
                onChange: (String? value) =>
                    provider.onSecondorySelection(value),
              ),
              CustomTextFormField(
                title: 'Name',
                controller: _name,
                hint: 'Product Name',
                validator: (String? value) => CustomValidator.lessThen3(value),
              ),
              CustomTextFormField(
                title: 'Price',
                controller: _price,
                hint: 'Product Price',
                keyboardType: TextInputType.number,
                validator: (String? value) => CustomValidator.isEmpty(value),
              ),
              CustomTextFormField(
                title: 'Quantity',
                controller: _qty,
                hint: 'Product Quantity',
                keyboardType: TextInputType.number,
                validator: (String? value) => CustomValidator.isEmpty(value),
              ),
              CustomTextFormField(
                title: 'Description',
                controller: _description,
                hint: 'Product detail description here',
                textInputAction: TextInputAction.done,
                validator: (String? value) => CustomValidator.isEmpty(value),
                maxLines: 4,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate() &&
                        _image != null &&
                        provider.selectedPri != null &&
                        provider.selectedSec != null) {
                      if (await ProductFirebaseAPI()
                          .isProductIDAvailable(pid: _barcode.text.trim())) {
                        showLoadingDislog(context);
                        final String? imageURL = await ProductFirebaseAPI()
                            .uploadImage(File(_image!.path), _barcode.text);
                        final Product product = Product(
                          pid: _barcode.text.trim(),
                          name: _name.text.trim(),
                          imageURL: imageURL,
                          priID: provider.selectedPri,
                          secID: provider.selectedSec,
                          price: double.parse(_price.text.trim()),
                          qty: int.parse(_qty.text.trim()),
                          description: _description.text.trim(),
                        );
                        await ProductFirebaseAPI().addProduct(product: product);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          HomeScreen.routeName,
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        CustomToast.errorToast(
                          message: 'Product ID Already Assign to a product',
                        );
                      }
                    } else {
                      CustomToast.errorToast(
                        message: 'Fill all requirements',
                      );
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 3),
            ],
          ),
        ),
      ),
    );
  }

  Row _selectScanBarcodeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const Expanded(
          child: Text(
            'Write ID OR click scan barcode',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        IconButton(
          onPressed: () async => _barcodeScanning(),
          splashRadius: 24,
          icon: const Icon(
            CupertinoIcons.barcode_viewfinder,
            size: 34,
          ),
        )
      ],
    );
  }

  Future<void> _barcodeScanning() async {
    try {
      final ScanResult scaned = await BarcodeScanner.scan();
      final String scanResult = scaned.rawContent;
      setState(() => _barcode.text = scanResult);
    } catch (e) {
      // TODO: Display Error
    }
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
                      borderRadius: BorderRadius.circular(10)),
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
                      borderRadius: BorderRadius.circular(10)),
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
