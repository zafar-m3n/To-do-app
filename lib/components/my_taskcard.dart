import 'package:flutter/material.dart';
import 'package:ver_1/pages/edit_task_page.dart';
import 'package:expandable/expandable.dart';

class TaskCard extends StatefulWidget {
  TaskCard({Key? key}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      collapsed: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: buildCardContent(isCollapsed: true),
      ),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: buildCardContent(isCollapsed: false),
      ),
    );
  }

  Widget buildCardContent({required bool isCollapsed}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImage(),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Sample Task Title',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: isDone,
                      onChanged: (value) {
                        setState(() {
                          isDone = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Sample task description goes here. This can be a bit longer, but will be truncated if the card is collapsed.',
                  maxLines: isCollapsed ? 1 : null,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue.shade400,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    buildTimeContainer(),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Edit_Screen(),
                        ));
                      },
                      child: buildEditContainer(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildImage() {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: AssetImage('images/sample_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container buildTimeContainer() {
    return Container(
      width: 90,
      height: 28,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 2),
            Text(
              '12:00 PM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildEditContainer() {
    return Container(
      width: 90,
      height: 28,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              'edit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
