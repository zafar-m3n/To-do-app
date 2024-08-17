import 'package:flutter/material.dart';

class GoogleLoginBtn extends StatelessWidget {
  final Function()? onTap;
  final String buttonText; // New parameter for the button text

  const GoogleLoginBtn({
    Key? key,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset('images/1.png'),
            const Icon(
              Icons.account_circle,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
