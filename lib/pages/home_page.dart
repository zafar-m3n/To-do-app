import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ver_1/pages/add_task_page.dart';
import 'package:ver_1/components/my_taskcard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: Visibility(
          visible: show,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Add_Screen()),
              );
            },
            backgroundColor: Colors.blue.shade400,
            child: Icon(Icons.add),
          ),
        ),
        body: SafeArea(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.forward) {
                  setState(() {
                    show = true;
                  });
                } else if (notification.direction == ScrollDirection.reverse) {
                  setState(() {
                    show = false;
                  });
                }
              }
              return true;
            },
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return TaskCard();
              },
            ),
          ),
        ));
  }
}
