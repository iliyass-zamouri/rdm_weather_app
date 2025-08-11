import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rdm_weather_app/core/utils/search_field.dart';

class SearchSection extends HookConsumerWidget {
  final String? label;
  final bool isLoading;
  final Function(String) onSearch;
  final Function() onClear;
  const SearchSection({
    super.key,
    required this.onSearch,
    required this.onClear,
    this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cityController = useTextEditingController();
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16, bottom: 16),
      child: SearchField(
        controller: cityController,
        isLoading: isLoading,
        label: "Rechercher une ville",
        suffix: CupertinoIcons.search,
        clear: cityController.text.isNotEmpty ? CupertinoIcons.clear : null,
        onClear: () {
          cityController.clear();
          onClear();
        },
        onSuffix: () {
          final city = cityController.text.trim();
          if (city.isNotEmpty) {
            FocusScope.of(context).unfocus();
            onSearch(city);
          }
        },
      ),
    );
  }
}
