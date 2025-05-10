import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  final String title;

  const MainHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            children: [
              _buildIcon(Icons.notifications),
              _buildIcon(Icons.account_circle),
              _buildIcon(Icons.settings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: Colors.blueGrey),
      onPressed: () {
        // تنفيذ الإجراء المناسب
      },
    );
  }
}
