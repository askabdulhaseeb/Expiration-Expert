import 'package:flutter/material.dart';
import '../../database/product_firebase_api.dart';
import '../../model/product.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/images.dart';
import '../../utilities/utilities.dart';
import '../home_screen/home_screen.dart';
import '../widgets/show_loading.dart';
import '../widgets/custom_textformfield.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({required this.product, Key? key}) : super(key: key);
  static const String routeName = '/EditProductScreen';
  final Product product;
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  // late TextEditingController _barcode = TextEditingController();
  late TextEditingController _name = TextEditingController();
  late TextEditingController _description = TextEditingController();
  late TextEditingController _qty = TextEditingController();
  late TextEditingController _price = TextEditingController();
  @override
  void initState() {
    _name = TextEditingController(text: widget.product.name);
    _description = TextEditingController(text: widget.product.description);
    _qty = TextEditingController(text: widget.product.qty.toString());
    _price = TextEditingController(text: widget.product.price.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 1.4,
                    width: double.infinity,
                    child: Center(
                      child: (widget.product.imageURL == null)
                          ? Image.asset(CustomImages.appLogo)
                          : Image.network(widget.product.imageURL!,
                              fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Utilities.padding),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          _productIDRow(context),
                          CustomTextFormField(
                            title: 'Name',
                            controller: _name,
                            hint: 'Product Name',
                            validator: (String? value) =>
                                CustomValidator.lessThen3(value),
                          ),
                          CustomTextFormField(
                            title: 'Quantity',
                            controller: _qty,
                            hint: 'Product Quantity',
                            validator: (String? value) =>
                                CustomValidator.isEmpty(value),
                          ),
                          CustomTextFormField(
                            title: 'Price',
                            controller: _price,
                            hint: 'Product Price',
                            validator: (String? value) =>
                                CustomValidator.isEmpty(value),
                          ),
                          CustomTextFormField(
                            title: 'Description',
                            controller: _description,
                            hint: 'Product Description',
                            maxLines: 6,
                            validator: (String? value) =>
                                CustomValidator.isEmpty(value),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  showLoadingDislog(context);
                  widget.product.name = _name.text;
                  widget.product.qty = int.parse(_qty.text);
                  widget.product.price = double.parse(_price.text);
                  widget.product.description = _description.text;
                  await ProductFirebaseAPI()
                      .updateProduct(product: widget.product);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.routeName,
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(fontSize: 22),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row _productIDRow(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Product ID: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          widget.product.pid ?? 'No Found',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
