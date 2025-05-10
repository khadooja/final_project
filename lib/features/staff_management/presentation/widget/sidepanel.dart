import 'package:flutter/material.dart';

class SidePanel extends StatelessWidget {
  final String adminName;
  final String email;
  final List<Map<String, String>> stats;

  const SidePanel(
      {super.key,
      required this.adminName,
      required this.email,
      required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 40)),
          const SizedBox(height: 8),
          Text(adminName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const Divider(),
          ...stats
              .map((stat) => _buildStatCard(stat['title']!, stat['value']!)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing:
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
