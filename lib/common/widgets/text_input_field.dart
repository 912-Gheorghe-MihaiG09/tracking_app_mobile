import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';

class TextInputField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool enableSpaceKey;
  final bool onlyAlpha;
  final TextCapitalization textCapitalization;
  final int characterLimit;
  final Color fillColor;
  final AutovalidateMode autoValidateMode;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputFieldType type;
  final BoxConstraints? constraints;
  final EdgeInsets? contentPadding;
  final bool filled;
  final String? helperText;

  const TextInputField(
      {Key? key,
      this.labelText,
      this.hintText,
      this.onFieldSubmitted,
      this.keyboardType,
      this.textInputAction,
      this.validator,
      required this.controller,
      this.onChanged,
      this.enableSpaceKey = false,
      this.onlyAlpha = false,
      this.textCapitalization = TextCapitalization.none,
      this.characterLimit = -1,
      this.fillColor = AppColors.white,
      this.autoValidateMode = AutovalidateMode.onUserInteraction,
      this.type = TextInputFieldType.clear,
      this.focusNode,
      this.constraints,
      this.filled = true,
      this.contentPadding,
      this.helperText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextInputFieldState();
  }
}

class _TextInputFieldState extends State<TextInputField> {
  bool _wasOnChangedCalled = true;
  bool _obscureText = false;
  late FocusNode _focusNode;
  bool _isSelected = false;
  final double _inputFieldBorderRadius = 2;

  @override
  void initState() {
    _obscureText = widget.type == TextInputFieldType.password;
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isSelected = _focusNode.hasFocus;
      });
    });
    if (widget.autoValidateMode == AutovalidateMode.always) {
      _wasOnChangedCalled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // there is no way withing material 3 to keep the label inside the border
        // here we have a custom solution stack:
        // containerWithFillColor -> textFieldWithoutBorders -> containerWithBorders
        if (widget.filled)
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: widget.fillColor,
              borderRadius: BorderRadius.all(
                Radius.circular(_inputFieldBorderRadius),
              ),
            ),
            constraints: widget.constraints,
          ),
        Padding(
          // Padding is adjusted depending on the filled/unfilled style
          // this helps center the text while the label is on top of the field/ in the field
          padding: EdgeInsets.only(
              top: widget.filled
                  ? ((widget.controller.text.isEmpty && !_isSelected) ||
                          widget.labelText == null
                      ? 4
                      : 8)
                  : 0),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.characterLimit),
              //disable space key
              if (!widget.enableSpaceKey)
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              // deny anything other then alphabetic chars
              if (widget.onlyAlpha)
                FilteringTextInputFormatter.deny(RegExp(
                    r'[^a-zA-ZÈÉÊËÙÚÛÜÎÌÍÏÒÓÔÖÂÀÁÄẞÇèéêëùúûüîìíïòóôöâàáäsßç\-\s]')),
            ],
            cursorColor: AppColors.black,
            onFieldSubmitted: widget.onFieldSubmitted,
            focusNode: widget.focusNode ?? _focusNode,
            validator: widget.validator,
            textCapitalization: widget.textCapitalization,
            autovalidateMode: widget.autoValidateMode,
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: (_) {
              _wasOnChangedCalled = false;

              if (widget.onChanged != null) {
                widget.onChanged!.call(_);
              } else {
                // if noChanged function is provided we still need to setState
                // so the label/border colors change
                setState(() {});
              }
            },
            decoration: widget.filled
                ? _getDecorationForFilledStyle()
                : InputDecoration(
                    helperText: _isSelected ? widget.helperText : null,
                    enabledBorder: widget.controller.text.isNotEmpty
                        ? Theme.of(context)
                            .inputDecorationTheme
                            .enabledBorder
                            ?.copyWith(
                                borderSide:
                                    const BorderSide(color: AppColors.primary))
                        : null,
                    labelText: widget.labelText,
                    labelStyle: widget.controller.text.isNotEmpty || _isSelected
                        ? Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: _getLabelColor())
                        : null,
                    constraints: widget.constraints,
                    contentPadding: widget.contentPadding,
                    hintText: widget.hintText,
                    suffixIcon: _getTrailingButton(),
                  ),
          ),
        ),
        if (widget.filled)
          IgnorePointer(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_inputFieldBorderRadius),
                border: Border.all(
                  color: _getLabelColor(),
                ),
              ),
              constraints: widget.constraints,
            ),
          ),
      ],
    );
  }

  Widget? _getTrailingButton() {
    switch (widget.type) {
      case TextInputFieldType.normal:
        return null;
      case TextInputFieldType.password:
        return widget.controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.black,
                ),
                onPressed: () => setState(() {
                  _obscureText = !_obscureText;
                }),
              )
            : null;
      case TextInputFieldType.clear:
        return widget.controller.text.isNotEmpty
            ? Material(
                type: MaterialType.transparency,
                child: IconButton(
                  onPressed: () => setState(() {
                    widget.controller.text = "";
                    widget.focusNode?.requestFocus();
                    widget.onChanged != null ? widget.onChanged!("") : null;
                  }),
                  icon: SvgPicture.asset(
                      "assets/images/common/close.svg"),
                ),
              )
            : null;
    }
  }

  Color _getLabelColor() {
    if (widget.validator?.call(widget.controller.text) != null &&
        !_wasOnChangedCalled) {
      return AppColors.errorRed;
    }
    return _isSelected || widget.controller.text.isNotEmpty
        ? AppColors.primary
        : AppColors.black;
  }

  InputDecoration _getDecorationForFilledStyle() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.transparent),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.transparent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.transparent),
      ),
      contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      filled: widget.filled,
      helperText: _isSelected ? widget.helperText : null,
      labelText: widget.labelText,
      labelStyle: widget.controller.text.isNotEmpty || _isSelected
          ? Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: _getLabelColor(), fontWeight: FontWeight.w500)
          : null,
      constraints: widget.constraints,
      hintText: widget.hintText,
      suffixIcon: _getTrailingButton(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
}

enum TextInputFieldType {
  normal,
  password,
  clear,
}
