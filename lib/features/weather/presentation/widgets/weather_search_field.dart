import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rdm_weather_app/core/utils/colors.dart';

class WeatherSearchField extends StatelessWidget {
  final String? label;
  final String? defaultValue;
  final TextEditingController? controller;
  final Object? clear;
  final Object? suffix;
  final double? iconSize;
  final bool overallMargin;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool? obscure;
  final bool disabled;
  final bool isLoading;
  final bool important;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSuffix;
  const WeatherSearchField({
    super.key,
    this.label,
    this.defaultValue,
    this.controller,
    this.clear,
    this.suffix,
    this.overallMargin = true,
    this.iconSize = 20,
    this.keyboardType,
    this.maxLines = 1,
    this.obscure,
    this.disabled = false,
    this.isLoading = false,
    this.important = true,
    this.onChanged,
    this.onClear,
    this.onSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: overallMargin
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : EdgeInsets.zero,
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
        // border: Border.all(
        //   color: Colors.grey.withOpacity(0.5),
        //   width: 1,
        // ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              initialValue: defaultValue,
              controller: controller,
              maxLines: maxLines,
              minLines: 1,
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

                // prefixText: prefix,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: obscure ?? false,
              enabled: !disabled,
              onChanged: onChanged,
              validator: (value) => important
                  ? (value == null || value.isEmpty
                      ? 'Ce champ est requis'
                      : null)
                  : null,
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
