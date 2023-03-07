import 'package:blackmarket_app/product_page/radio_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadioGroup<T> extends StatefulWidget {
  const RadioGroup({ Key? key, required this.child, this.onValueChanged }) : super(key: key);

  @override
  _RadioGroupState<T> createState() => _RadioGroupState<T>();


  final Widget child;
  final void Function(T newValue)? onValueChanged;
}

class _RadioGroupState<T> extends State<RadioGroup> {
  @override
  void initState() {
    super.initState();

    _controller.attachWidget(onValueChanged: widget.onValueChanged);
  }
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RadioGroupController<T>>(
      create: (context) => _controller,
      child: widget.child
    );
  }


  final RadioGroupController<T> _controller = new RadioGroupController<T>();
}