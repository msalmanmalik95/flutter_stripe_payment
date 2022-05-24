import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/blocs/stripe_payment.dart';
import 'package:stripe_payment/model/catalog_model.dart';
import 'package:stripe_payment/widgets/snackbar_widget.dart';

class CartController extends GetxController {
  StripePaymentBloc stripePaymentBloc = StripePaymentBloc();

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
    try {
      /// call Payment intent api
      await callPaymentIntentAPI(price: totalPrice.toString());

      /// Payment sheet initialization
      await initPaymentSheet();

      /// Now finally display payment sheet
      await displayPaymentSheet();
    } catch (e) {
      print('Exception : ' + e.toString());
    }
  }

  Future<void> callPaymentIntentAPI({required String price}) async {
    isProgress(true);
    paymentIntentData = await stripePaymentBloc.callPaymentIntent(
      calculateAmount(price),
      'USD',
    );
    isProgress(false);
  }

  Future<String> initPaymentSheet() async {
    try {
      return await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  currencyCode: 'usd',
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'Salman'))
          .then((value) {
        print("Success initPaymentSheet ");
        return 'Success';
      }).onError((error, stackTrace) {
        print("Error initPaymentSheet " + error.toString());
        return 'Error';
      });
    } catch (e) {
      print('Exception : ' + e.toString());
      return 'Exception';
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        showSnackBar("Success", "Payment Successfully");
        clearList();
        print('payment intent ===> ' + paymentIntentData!['id'].toString());

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception onError ==> $error $stackTrace');
        // showSnackBar("Cancel", "Payment canceled");
      });
    } on StripeException catch (e) {
      print('Exception ==> $e');
      showSnackBar("Exception", "Payment failed");
    } catch (e) {
      print('$e');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
