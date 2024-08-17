import 'package:flutter/material.dart';
import 'package:ver_1/pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'package:ver_1/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tick Off',
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUp(),
        '/': (context) => LoginPage(),
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
