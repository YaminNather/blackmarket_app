import 'package:blackmarket_app/product_page/radio_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadioButton<T> extends StatefulWidget {
  const RadioButton({ Key? key, required this.value, required this.notSelected, this.pressing, required this.onSelected }) : super(key: key);

  @override
  _RadioButtonState<T> createState() => _RadioButtonState<T>();


  final T value;
  final Widget notSelected;
  final Widget? pressing;
  final Widget onSelected;
}

class _RadioButtonState<T> extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    final RadioGroupController<T> controller = Provider.of<RadioGroupController<T>>(context);
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      elevation: 0.0,
      child: InkWell(
        onTap: () => controller.setValue(widget.value),
        child: _buildMain(),
      ),
    );    
  }

  Widget _buildMain() {
    final RadioGroupController<T> controller = Provider.of<RadioGroupController<T>>(context);

    if(controller.value != widget.value)
      return widget.notSelected;
    else
      return widget.onSelected;
  }
}