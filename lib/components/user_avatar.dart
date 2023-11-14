import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String userName;
  final double radius;

  const UserAvatar({super.key, required this.userName, this.radius = 24.0});

  @override
  Widget build(BuildContext context) {
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    final color = _getColorForName(userName);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }

  Color _getColorForName(String name) {
    // You can implement a logic here to generate a unique color based on the user's name.
    // For simplicity, we'll use random colors.
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.pink,
      Colors.deepOrange,
      Colors.lightGreen,
    ];

    final index = name.isNotEmpty ? name.codeUnitAt(0) % colors.length : 0;
    return colors[index];
  }
}
