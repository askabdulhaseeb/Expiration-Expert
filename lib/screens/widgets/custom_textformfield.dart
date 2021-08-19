import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utilities/utilities.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.title,
    required TextEditingController controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.initialValue,
    this.hint,
    this.readOnly = false,
    this.autoFocus = false,
    this.padding = 4,
    this.isPassword = false,
    this.maxLines = 1,
    Key? key,
  })  : _controller = controller,
        super(key: key);
  final TextEditingController _controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? initialValue;
  final String title;
  final String? hint;
  final bool readOnly;
  final bool autoFocus;
  final bool isPassword;
  final double padding;
  final int? maxLines;

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isVisible = false;
  void _onListen() => setState(() {});

  @override
  void initState() {
    widget._controller.addListener(_onListen);
    super.initState();
  }

  @override
  void dispose() {
    widget._controller.removeListener(_onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.padding),
      child: TextFormField(
        initialValue: widget.initialValue,
        controller: widget._controller,
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType,
        autofocus: widget.autoFocus,
        textInputAction: TextInputAction.next,
        maxLines: widget.maxLines,
        // ignore: avoid_bool_literals_in_conditional_expressions
        obscureText: (widget.isPassword == true)
            ? (isVisible == true)
                ? !isVisible
                : !isVisible
            : false,
        validator: (String? value) => widget.validator!(value),
        inputFormatters: (widget.keyboardType == TextInputType.number)
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : <TextInputFormatter>[FilteringTextInputFormatter.deny('\n')],
        decoration: InputDecoration(
          labelText: widget.title,
          hintText: widget.hint,
          suffixIcon: (widget.isPassword)
              ? (isVisible == false)
                  ? IconButton(
                      onPressed: () => setState(() => isVisible = true),
                      icon: const Icon(CupertinoIcons.eye),
                    )
                  : IconButton(
                      onPressed: () => setState(() => isVisible = false),
                      icon: const Icon(CupertinoIcons.eye_slash),
                    )
              : (widget._controller.text.isEmpty)
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () => widget._controller.clear(),
                      icon: const Icon(Icons.clear),
                    ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Utilities.borderRadious),
          ),
        ),
      ),
    );
  }
}
