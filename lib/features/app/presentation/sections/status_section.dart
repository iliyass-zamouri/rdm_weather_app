import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rdm_weather_app/core/utils/status_bar.dart';

class StatusSection extends ConsumerWidget {
  final String? error;
  final bool isLoading;
  const StatusSection({super.key, this.error, this.isLoading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if (isLoading) {
      return StatusBar.loading();
    }

    if (error != null) {
      return StatusBar.error(
        icon: CupertinoIcons.exclamationmark_triangle,
        message: error,
      );
    }

    return const SizedBox.shrink();
  }
}