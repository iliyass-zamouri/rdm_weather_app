import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;

  const StatusBar({super.key, required this.isLoading, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
