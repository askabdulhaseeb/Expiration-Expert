import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/user_local_data.dart';
import 'providers/primary_category_provider.dart';
import 'screens/add_admin_screen/add_admin_screen.dart';
import 'screens/add_product_screen/add_product_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/login_screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserLocalData.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        ChangeNotifierProvider<CategoryProvider>.value(
          value: CategoryProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expiration Expert',
        theme: ThemeData(
          primaryColor: Colors.blue,
          splashColor: Colors.blue[200],
          iconTheme: const IconThemeData(color: Colors.blue),
        ),
        home: (UserLocalData.getUserUID != '')
            ? const HomeScreen()
            : const LoginScreen(),
        routes: <String, WidgetBuilder>{
          LoginScreen.routeName: (_) => const LoginScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          AddProductScreen.routeName: (_) => const AddProductScreen(),
          // EditProductScreen.routeName: (_) => const EditProductScreen(),
          AddAdminScreen.routeName: (_) => const AddAdminScreen(),
        },
      ),
    );
  }
}

// Certificate fingerprints:
//   SHA1: F6:3C:6E:07:37:98:D1:37:8D:8D:AD:2B:80:BE:5E:2C:50:EF:71:F9
//   SHA256: B8:1F:B2:FF:CB:2E:A2:45:12:1B:22:43:35:C5:B6:CC:A5:3B:CE:D4:6B:97:93:EF:76:D9:81:0F:F9:16:4C:6E