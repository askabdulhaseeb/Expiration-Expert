import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class CustomInkWellButton extends StatelessWidget {
  const CustomInkWellButton({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Utilities.borderRadious),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 30,
            ),
            
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(Utilities.borderRadious),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
