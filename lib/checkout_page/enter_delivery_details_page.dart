import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';

import 'checkout_page_controller.dart';
import 'summary_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterDeliveryDetailsPage extends StatefulWidget {
  const EnterDeliveryDetailsPage({ Key? key }) : super(key: key);

  @override
  State<EnterDeliveryDetailsPage> createState() => _EnterDeliveryDetailsPageState();
}

class _EnterDeliveryDetailsPageState extends State<EnterDeliveryDetailsPage> {
  @override
  void initState() {
    super.initState();

    _buildingFieldController.addListener(_update);
    _streetFieldController.addListener(_update);
    _cityFieldController.addListener(_update);
    _stateFieldController.addListener(_update);
    _contactNumberFieldController.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed:() {
          final CheckoutPageController controller = Provider.of<CheckoutPageController>(context, listen: false);
          controller.goBack();
        }
      ),
      title: const Text('Delivery Details')
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _buildingFieldController, 
              decoration: const InputDecoration(hintText: "Building")
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: _streetFieldController, 
              decoration: const InputDecoration(hintText: "Street")
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: _cityFieldController, 
              decoration: const InputDecoration(hintText: "City")
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: _stateFieldController, 
              decoration: const InputDecoration(hintText: "State")
            ),

            const SizedBox(height: 16.0),

            TextField(
              controller: _contactNumberFieldController, 
              decoration: const InputDecoration(hintText: "Contact Number"),
              keyboardType: TextInputType.number
            ),

            const SizedBox(height: 16.0),

            _buildNextButton()
          ]
        )
      )
    );
  }

  Widget _buildNextButton() {
    Future<void> onPressed() async {
      final CheckoutPageController controller = Provider.of<CheckoutPageController>(context, listen: false);
      
      final Address address = Address(
        building: _buildingFieldController.text,
        street: _streetFieldController.text,
        city: _cityFieldController.text,
        state: _stateFieldController.text
      );      
      controller.setDeliveryDetails(address, _contactNumberFieldController.text);

      final MaterialPageRoute route = MaterialPageRoute(builder: (context) => const SummaryPage());
      await Navigator.of(context).push(route);
    }

    bool isEnabled = _buildingFieldController.text.isNotEmpty;
    isEnabled = isEnabled && _streetFieldController.text.isNotEmpty;
    isEnabled = isEnabled && _cityFieldController.text.isNotEmpty;
    isEnabled = isEnabled && _stateFieldController.text.isNotEmpty;
    isEnabled = isEnabled && _contactNumberFieldController.text.isNotEmpty;


    return ElevatedButton(child: const Text('Next'), onPressed: (isEnabled) ? onPressed : null);
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    _buildingFieldController.removeListener(_update);
    _streetFieldController.removeListener(_update);
    _cityFieldController.removeListener(_update);
    _stateFieldController.removeListener(_update);
    _contactNumberFieldController.removeListener(_update);

    super.dispose();
  }

  final TextEditingController _buildingFieldController = TextEditingController();
  final TextEditingController _streetFieldController = TextEditingController();
  final TextEditingController _cityFieldController = TextEditingController();
  final TextEditingController _stateFieldController = TextEditingController();
  final TextEditingController _contactNumberFieldController = TextEditingController();
}