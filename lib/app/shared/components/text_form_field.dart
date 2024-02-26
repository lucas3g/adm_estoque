// ignore_for_file: must_be_immutable

import 'package:adm_estoque/app/shared/domain/entities/app_theme_constants.dart';
import 'package:adm_estoque/app/shared/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatefulWidget {
  TextEditingController? controller;
  final String title;
  final String hint;
  final String? value;
  final String? Function(String?)? validator;
  Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? keyboardType;
  bool hideInput;
  bool textArea;
  Color? borderColor;
  void Function()? onTap;
  FocusNode? focusNode;
  Function(String)? onFieldSubmitted;
  TextInputAction? textInputAction;
  bool readOnly;

  AppTextFormField({
    Key? key,
    this.controller,
    required this.title,
    required this.hint,
    this.onChanged,
    this.value,
    this.validator,
    this.hideInput = false,
    this.textArea = false,
    this.borderColor,
    this.inputFormatters,
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _hideInput;

  @override
  void initState() {
    super.initState();
    _hideInput = widget.hideInput;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      initialValue: widget.value,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      obscureText: _hideInput,
      controller: widget.controller,
      cursorColor: widget.borderColor ?? context.colorScheme.background,
      style: context.textTheme.bodyLarge?.copyWith(
        color: widget.borderColor ?? context.colorScheme.background,
        decorationColor: Colors.transparent,
        decorationThickness: 0,
      ),
      decoration: InputDecoration(
        isDense: true,
        label: Text(widget.title),
        labelStyle: context.textTheme.bodyLarge?.copyWith(
          color: widget.borderColor ?? context.colorScheme.background,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? context.colorScheme.background,
          ),
          borderRadius: BorderRadius.circular(
            AppThemeConstants.mediumBorderRadius,
          ),
        ),
        errorStyle: context.textTheme.bodyMedium?.copyWith(
          color: widget.borderColor ?? context.colorScheme.background,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? context.colorScheme.background,
          ),
          borderRadius: BorderRadius.circular(
            AppThemeConstants.mediumBorderRadius,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? context.colorScheme.background,
          ),
          borderRadius: BorderRadius.circular(
            AppThemeConstants.mediumBorderRadius,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? context.colorScheme.background,
          ),
          borderRadius: BorderRadius.circular(
            AppThemeConstants.mediumBorderRadius,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor ?? context.colorScheme.background,
          ),
          borderRadius: BorderRadius.circular(
            AppThemeConstants.mediumBorderRadius,
          ),
        ),
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: widget.borderColor ??
              context.colorScheme.background.withAlpha(150),
        ),
        hintText: widget.hint,
        suffixIcon: widget.hideInput
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _hideInput = !_hideInput;
                  });
                },
                icon: Icon(
                  !_hideInput ? Icons.visibility : Icons.visibility_off,
                  color: widget.borderColor ?? context.colorScheme.background,
                ),
              )
            : null,
      ),
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
    );
  }
}
