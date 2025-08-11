import 'package:flutter/material.dart';

class StatusBar {
  static Widget loading() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  static Widget error({IconData? icon, String? message}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 8),
            ],
            if (message != null)
              Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  static Widget initial({IconData? icon, String? message}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 8),
            ],
            if (message != null)
              Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
