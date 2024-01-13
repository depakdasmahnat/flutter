import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_config.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'We are a Flutter development company based in XYZ. We specialize in creating high-quality Flutter apps for businesses and startups. Our team consists of experienced developers and designers who are passionate about creating beautiful and functional apps.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Contact Us',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${AppConfig.contactEmail}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Phone:  ${AppConfig.contactNumber}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
