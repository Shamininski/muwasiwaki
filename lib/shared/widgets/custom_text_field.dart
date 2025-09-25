// lib/shared/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final bool isRequired;
  final FocusNode? focusNode;
  final TextStyle? style;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final bool filled;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final String? helperText;
  final TextStyle? helperStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool isDense;
  final bool expands;
  final String? semanticCounterText;
  final Widget? counter;
  final String? counterText;
  final TextStyle? counterStyle;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.isRequired = false,
    this.focusNode,
    this.style,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.helperText,
    this.helperStyle,
    this.errorText,
    this.errorStyle,
    this.floatingLabelBehavior,
    this.isDense = false,
    this.expands = false,
    this.semanticCounterText,
    this.counter,
    this.counterText,
    this.counterStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      key: key,
      initialValue: initialValue,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: style,
      textAlign: textAlign,
      expands: expands,
      decoration: InputDecoration(
        labelText: _buildLabelText(),
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        suffixText: suffixText,
        helperText: helperText,
        helperStyle: helperStyle,
        errorText: errorText,
        errorStyle: errorStyle,
        counterText:
            maxLength != null && counterText == null ? null : counterText,
        counter: counter,
        counterStyle: counterStyle,
        floatingLabelBehavior: floatingLabelBehavior,
        isDense: isDense,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
        filled: filled,
        fillColor: fillColor ?? theme.inputDecorationTheme.fillColor,
        border: border ?? _defaultBorder(theme),
        enabledBorder: enabledBorder ?? _defaultEnabledBorder(theme),
        focusedBorder: focusedBorder ?? _defaultFocusedBorder(theme),
        errorBorder: errorBorder ?? _defaultErrorBorder(theme),
        focusedErrorBorder:
            focusedErrorBorder ?? _defaultFocusedErrorBorder(theme),
        semanticCounterText: semanticCounterText,
      ),
    );
  }

  String? _buildLabelText() {
    if (label == null) return null;
    return isRequired ? '$label *' : label;
  }

  InputBorder _defaultBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.dividerColor,
        width: 1,
      ),
    );
  }

  InputBorder _defaultEnabledBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.dividerColor,
        width: 1,
      ),
    );
  }

  InputBorder _defaultFocusedBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.primaryColor,
        width: 2,
      ),
    );
  }

  InputBorder _defaultErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 1,
      ),
    );
  }

  InputBorder _defaultFocusedErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 2,
      ),
    );
  }
}

// Helper class for additional text field configurations
class TextFieldConfig {
  static List<TextInputFormatter> phoneNumberFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(15),
    ];
  }

  static List<TextInputFormatter> emailFormatters() {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // No spaces
      LengthLimitingTextInputFormatter(100),
    ];
  }

  static List<TextInputFormatter> nameFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-']")),
      LengthLimitingTextInputFormatter(50),
    ];
  }

  static List<TextInputFormatter> numericFormatters({int? maxLength}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  static List<TextInputFormatter> decimalFormatters({int? decimalPlaces}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      if (decimalPlaces != null)
        TextInputFormatter.withFunction((oldValue, newValue) {
          final parts = newValue.text.split('.');
          if (parts.length > 2) return oldValue;
          if (parts.length == 2 && parts[1].length > decimalPlaces) {
            return oldValue;
          }
          return newValue;
        }),
    ];
  }

  static List<TextInputFormatter> alphabeticFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
    ];
  }

  static List<TextInputFormatter> alphanumericFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
    ];
  }

  // Common input decoration themes
  static InputDecoration searchFieldDecoration({
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onClear,
  }) {
    return InputDecoration(
      hintText: hint ?? 'Search...',
      prefixIcon: prefixIcon ?? const Icon(Icons.search),
      suffixIcon: suffixIcon ??
          (onClear != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static InputDecoration roundedFieldDecoration({
    String? label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isRequired = false,
  }) {
    return InputDecoration(
      labelText: isRequired && label != null ? '$label *' : label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static InputDecoration underlineFieldDecoration({
    String? label,
    String? hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isRequired = false,
  }) {
    return InputDecoration(
      labelText: isRequired && label != null ? '$label *' : label,
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: const UnderlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}
