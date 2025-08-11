import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rdm_weather_app/core/utils/colors.dart';

class SearchField extends StatelessWidget {
  final String? label;
  final String? defaultValue;
  final TextEditingController? controller;
  final Object? clear;
  final Object? suffix;
  final double? iconSize;
  final TextInputType? keyboardType;
  final bool disabled;
  final bool isLoading;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSuffix;
  const SearchField({
    super.key,
    this.label,
    this.defaultValue,
    this.controller,
    this.clear,
    this.suffix,
    this.iconSize = 20,
    this.keyboardType,
    this.disabled = false,
    this.isLoading = false,
    this.validator,
    this.onChanged,
    this.onClear,
    this.onSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: defaultValue,
              controller: controller,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: InputDecoration(
                hintText: label,
                isDense: true,
                contentPadding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 0,
                  bottom: 12,
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
              ),
              enabled: !disabled,
              onChanged: onChanged,
              validator: validator,
              keyboardType: keyboardType ?? TextInputType.text,
            ),
          ),
          if (clear != null && !isLoading) ...[
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: clear is IconData
                    ? Icon(
                        clear as IconData,
                        color: AppColors.primary,
                        size: iconSize,
                      )
                    : Text(
                        clear.toString(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade50,
            ),
          ],
          if (suffix != null && !isLoading) ...[
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade50,
            ),
            GestureDetector(
              onTap: onSuffix,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: suffix is IconData
                    ? Icon(
                        suffix as IconData,
                        color: AppColors.primary,
                        size: iconSize,
                      )
                    : Text(
                        suffix.toString(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ] else if (isLoading) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: SizedBox(
                width: iconSize,
                height: iconSize,
                child: const CupertinoActivityIndicator(
                  radius: 10,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
