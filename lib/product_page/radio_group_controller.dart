import 'package:flutter/material.dart';

class RadioGroupController<TValue> extends ChangeNotifier {
  void setValue(TValue newValue) {
    if(newValue == value)
      return;

    value = newValue;
    onValueChanged?.call(newValue);

    notifyListeners();
  }

  void attachWidget({void Function(TValue newValue)? onValueChanged}) {
    this.onValueChanged = onValueChanged;
  }


  TValue? value;
  void Function(TValue newValue)? onValueChanged;
}