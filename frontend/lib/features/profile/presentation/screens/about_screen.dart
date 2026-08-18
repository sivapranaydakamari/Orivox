import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Column(
                children: [
                  Icon(Icons.rocket_launch, size: 64, color: Colors.blue),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Orivox Platform',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Version 1.0.0'),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () {
              // Usually opens a URL
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Usually opens a URL
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Open Source Licenses'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Orivox',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.rocket_launch, size: 48),
              );
            },
          ),
        ],
      ),
    );
  }
}
