import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

import '../../../../core/widgets/orivox_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Orivox'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Column(
                children: [
                  OrivoxLogo(height: 72, isHero: true),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Orivox Platform',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Engineering Intelligence SaaS • Version 1.0.0',
                    style: TextStyle(color: Colors.grey),
                  ),
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
                applicationIcon: const OrivoxLogo(height: 48),
              );
            },
          ),
        ],
      ),
    );
  }
}
