import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:stripe_payment/Utils/stripe_keys.dart';
import 'package:stripe_payment/blocs/stripe_payment.dart';
import 'package:stripe_payment/controller/cart_controller.dart';
import 'package:stripe_payment/main.dart';
import 'package:stripe_payment/model/catalog_model.dart';

void main() async {
  addRemoveItemTest();
  callPaymentApi();
}

void addRemoveItemTest() {
  final controller = Get.put(CartController());

  group('Add or remove item ->', () {
    //Adding item
    test('Add Item test ->', () {
      final item = Item(id: 1, name: "test", price: 20);
      controller.add(item);
      expect(controller.items.length, 1);
      // controller.items
    });

    //Removing item
    test('Remove item test ->', () {
      final item = Item(id: 1, name: "test", price: 20);
      controller.remove(item);
      expect(controller.items.length, 0);
      // controller.items
    });
  });
}

void callPaymentApi() {
  group('Payment Test Cases ->', () {
    final stripePaymentBloc = StripePaymentBloc();
    final controller = Get.put(CartController());

    test('currency conversion', () async {
      var result = controller.calculateAmount('1');
      expect(result, '100');
    });

    test('test payment_intents api ', () async {
      await controller.callPaymentIntentAPI(price: '20');
      expect(controller.paymentIntentData!['client_secret'], isNotNull);
    });

    test('init and show payment sheet', () async {
      // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      TestWidgetsFlutterBinding.ensureInitialized();

      Stripe.publishableKey = publishableKey;
      Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
      // await Stripe.instance.applySettings();

      print(
          "client_secret => " + controller.paymentIntentData!['client_secret']);

      final response = await controller.initPaymentSheet();

      print("Salman => " + response);
      // debugDefaultTargetPlatformOverride = null;
      // expect(response, 'Success');
      // await controller.displayPaymentSheet();
    });
  });
}

void WidgetTest() {
  testWidgets('Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
