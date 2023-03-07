import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:blackmarket_backend_client/blackmarket_backend_client.dart';
import 'package:blackmarket_app/injector.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CompleteCheckout {
  CompleteCheckout(this.order, this.address, this.contactNumber);

  Future<void> completeCheckout() async {
    final Map<String, dynamic> createOrderResponse = await _createOrder();

    final Map<String, dynamic> checkoutOptions = <String, dynamic>{
      'key': 'rzp_test_cdaqGc6BKqUJz1',
      'amount': createOrderResponse['amount'],
      'name': 'Blackmarket Ltd.',
      'order_id': createOrderResponse['id'],
      'description': 'Payment for ${order.product.name}',
      'timeout': 60 // in seconds
    };

    await _makePayment(checkoutOptions);

    await _orderServices.completeCheckout(order.product.id, address, contactNumber);    
  }

  Future<Map<String, dynamic>> _createOrder() async {
    final Uri url = Uri.parse('https://api.razorpay.com/v1/orders');
    String basicAuth = 'Basic ';
    basicAuth += base64Encode(utf8.encode('rzp_test_cdaqGc6BKqUJz1:6RNDQkY2ymxGVsdOpVClYqKu'));
    final Map<String, String> headers = <String, String>{
      HttpHeaders.authorizationHeader: basicAuth,
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    final Map<String, dynamic> bodyJson = <String, dynamic>{
      'amount': order.amount,
      'currency': 'INR'
    };

    final http.Response response = await http.post(url, headers: headers, body: jsonEncode(bodyJson));
    
    final Map<String, dynamic> responseBodyJson = jsonDecode(response.body);
    return responseBodyJson;
  }

  Future<void> _makePayment(final Map<String, dynamic> options) {
    final Completer<void> completer = Completer<void>();

    final Razorpay razorpay = Razorpay();
    razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS, 
      (PaymentSuccessResponse response) {
        razorpay.clear();
        completer.complete();        
      }
    );
    razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      (PaymentFailureResponse response) {
        razorpay.clear();
        completer.completeError(response);
      }
    );
    razorpay.open(options);

    return completer.future;
  }



  final Order order;
  final Address address;
  final String contactNumber;

  final OrderServices _orderServices = getIt<Client>().orderServices();
}