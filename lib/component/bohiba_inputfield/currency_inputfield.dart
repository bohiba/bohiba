import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CurrencyInputField extends StatelessWidget {
  final bool autoFocus;
  final MoneyMaskedTextController currencyController;
  final InputDecoration decoration;
  final int maxLength;
  final Function(String)? onChanged;
  const CurrencyInputField({
    Key? key,
    this.autoFocus = false,
    this.maxLength = 10,
    this.decoration = const InputDecoration(
      counterText: "",
    ),
    this.onChanged,
    required this.currencyController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      maxLength: maxLength,
      textAlign: TextAlign.center,
      controller: currencyController,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headlineMedium,
      decoration: decoration,
      onChanged: onChanged,
    );
  }
}
