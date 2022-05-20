import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/Utils/stripe_keys.dart';
import 'package:stripe_payment/model/catalog_model.dart';
import 'package:stripe_payment/widgets/snackbar_widget.dart';

class CartController extends GetxController {
  final items = <Item>[].obs;

  var isProgress = false.obs;

  Map<String, dynamic>? paymentIntentData;

  /// The current total price of all items.
  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  void add(Item item) {
    items.add(item);
  }

  void remove(Item item) {
    items.remove(item);
    update();
  }

  void clearList() {
    items.clear();
    update();
  }

  Future<void> makePayment() async {
    /// call Payment intent api
    isProgress(true);
    paymentIntentData = await callPaymentIntent(totalPrice.toString(), 'USD');
    isProgress(false);

    /// Payment sheet initialization
    await initPaymentSheet();

    /// Now finally display payment sheet
    await displayPaymentSheet();
  }

  Future<void> initPaymentSheet() async {
    try {
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  currencyCode: 'usd',
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'Salman'))
          .then((value) {
        print("Success initPaymentSheet ");
      }).onError((error, stackTrace) {
        print("Error initPaymentSheet " + error.toString());
      });
    } catch (e) {
      print('Exception : ' + e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        showSnackBar("Success", "Payment Successfully");
        clearList();
        paymentIntentData = null;

        print('payment intent ===> ' + paymentIntentData!['id'].toString());
      }).onError((error, stackTrace) {
        print('Exception ==> $error $stackTrace');
        showSnackBar("Cancel", "Payment canceled");
      });
    } on StripeException catch (e) {
      print('Exception ==> $e');
      showSnackBar("Exception", "Payment failed");
    } catch (e) {
      print('$e');
    }
  }

  callPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent response ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (e) {
      print('Exception ===> ' + e.toString());
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
