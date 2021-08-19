import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class CustomSearch extends StatefulWidget {
  const CustomSearch({Key? key}) : super(key: key);

  @override
  _CustomSearchState createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.only(left: Utilities.padding + 4, top: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Search any product ...',
          border: InputBorder.none,
          suffixIcon: Icon(CupertinoIcons.search),
        ),
      ),
    );
  }
}
