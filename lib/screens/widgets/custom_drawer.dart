import 'package:flutter/material.dart';
import '../../database/auth.dart';
import '../../database/user_local_data.dart';
import '../add_admin_screen/add_admin_screen.dart';
import '../add_product_screen/add_product_screen.dart';
import '../login_screen/login_screen.dart';
import '../widgets/copyrights.dart';
import '../widgets/custom_image.dart';
import '../../utilities/utilities.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            _userInfo(),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            // Other Buttons
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text('Add Product'),
              onTap: () => Navigator.of(context).pushNamed(
                AddProductScreen.routeName,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_moderator_outlined),
              title: const Text('Add Admin'),
              onTap: () {
                Navigator.of(context).pushNamed(AddAdminScreen.routeName);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                AuthMethod().signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName,
                  (Route<dynamic> route) => false,
                );
              },
            ),
            Copyrights(),
          ],
        ),
      ),
    );
  }

  Row _userInfo() {
    return Row(
      children: <Widget>[
        CircularProfileImage(
          imageUrl: UserLocalData.getUserImageUrl,
          radius: 50,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                UserLocalData.getUserDisplayName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                ' ${UserLocalData.getUserEmail}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
