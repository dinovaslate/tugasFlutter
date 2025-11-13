import 'package:flutter/material.dart';

class FooterInfo extends StatelessWidget {
  const FooterInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: const Color(0xFF0B3D02),
      fontWeight: FontWeight.w600,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text('Nama: Haekal Alexander Dinova', style: textStyle),
        Text('NPM: 2406352424', style: textStyle),
        Text('Kelas: PBP C', style: textStyle),
      ],
    );
  }
}
