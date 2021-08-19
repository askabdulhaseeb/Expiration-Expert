import 'package:flutter/material.dart';
import '../../utilities/images.dart';

class CircularProfileImage extends StatelessWidget {
  const CircularProfileImage({required this.imageUrl, this.radius = 24.0});
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).primaryColor,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        radius: radius - 2,
        child: CircleAvatar(
          radius: radius - 6,
          backgroundColor: Theme.of(context).iconTheme.color,
          backgroundImage:
              (imageUrl == null || imageUrl == '' || imageUrl!.isEmpty)
                  ? AssetImage(CustomImages.appIcon) as ImageProvider
                  : NetworkImage(imageUrl!),
        ),
      ),
    );
  }
}
