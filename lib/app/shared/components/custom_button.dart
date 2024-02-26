// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class AppCustomButton extends StatelessWidget {
  final Widget label;
  final Widget icon;
  final Function()? onPressed;
  final bool expands;
  final double height;
  Color? backgroundColor;

  AppCustomButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.expands = false,
    this.height = 40,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    backgroundColor ??= context.colorScheme.primary;

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        textStyle: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        fixedSize: expands ? Size(context.screenWidth, height) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppThemeConstants.mediumBorderRadius,
          ),
        ),
      ),
      icon: icon,
      label: label,
    );
  }
}
