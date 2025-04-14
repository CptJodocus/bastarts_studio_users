import 'package:flutter/material.dart';

class BackupNetworkImage extends StatelessWidget {
  const BackupNetworkImage({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage(imageUrl ?? ''),
      errorBuilder:
          (context, error, stackTrace) => Image.asset(
            'assets/backup-banner.png',
            fit: BoxFit.cover,
            height: 300,
          ),
      height: 300,
      fit: BoxFit.cover,
    );
  }
}
