import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.onNavigate});
  final void Function(String path) onNavigate;

  @override
  Widget build(BuildContext context) {
    final routes = <_PreviewItem>[
      _PreviewItem(title: 'Init', path: '/'),
      _PreviewItem(title: 'Login', path: '/login'),
      _PreviewItem(title: 'Reset Password', path: '/login/resetPasswordRequest'),
      _PreviewItem(title: 'Home', path: '/home'),
      _PreviewItem(title: 'Main', path: '/main'),
      _PreviewItem(title: 'Profile', path: '/profile'),
      _PreviewItem(title: 'More', path: '/more'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Screen Preview')),
      body: ListView.separated(
        itemCount: routes.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = routes[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.path),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onNavigate(item.path),
          );
        },
      ),
    );
  }
}

class _PreviewItem {
  final String title;
  final String path;
  const _PreviewItem({required this.title, required this.path});
}

