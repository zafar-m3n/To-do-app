import 'package:flutter/material.dart';
import 'package:ver_1/pages/home_page.dart';
import 'package:ver_1/pages/login_page.dart';
import 'package:ver_1/pages/register_page.dart';
import 'package:ver_1/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Secure Storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize secure storage
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  
  // Check if the user is logged in
  String? isLoggedIn = await secureStorage.read(key: 'isLoggedIn');

  try {
    await dotenv.load(fileName: ".env");
    print(dotenv.env['BASE_URL']);
  } catch (e) {
    print("Error loading .env file: $e");
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(isLoggedIn: isLoggedIn == 'true'),
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tick Off',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: isLoggedIn ? HomePage() : LoginPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUp(),
        // '/': (context) => LoginPage(),
      },
    );
  }
}

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TaskPage();
  }
}
