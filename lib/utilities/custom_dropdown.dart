import 'package:flutter/material.dart';
import 'utilities.dart';

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    required List<DropdownMenuItem<String>> items,
    required this.selectedItem,
    required String hint,
    required Function onChange,
    this.readOnly = false,
    this.onPressIcon,
    this.icon = Icons.add,
    this.margin = 4,
    this.padding = 10,
    Key? key,
  })  : _items = items,
        _hint = hint,
        _onChange = onChange,
        super(key: key);

  final List<DropdownMenuItem<String>> _items;
  final String? selectedItem;
  final String _hint;
  final Function _onChange;
  final bool readOnly;
  final VoidCallback? onPressIcon;
  final IconData icon;
  final double margin, padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: padding / 2),
            margin: EdgeInsets.only(left: margin, top: 4, bottom: 4),
            decoration: BoxDecoration(
              border: Border.all(width: 1.2, color: Colors.grey),
              borderRadius: BorderRadius.circular(Utilities.borderRadious),
            ),
            child: DropdownButton<String>(
              value: selectedItem,
              items: _items,
              onChanged: (String? value) => _onChange(value),
              hint: Text(_hint),
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
        ),
        if (!readOnly)
          IconButton(
            splashRadius: 18,
            onPressed: onPressIcon,
            icon: Icon(icon),
          ),
      ],
    );
  }
}
