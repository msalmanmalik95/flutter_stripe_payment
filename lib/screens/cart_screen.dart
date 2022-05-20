import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/controller/cart_controller.dart';
import 'package:stripe_payment/widgets/empty_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headline5),
      ),
      body: Container(
        color: Colors.white70,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _CartList(),
              ),
            ),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.headline6;

    return GetBuilder<CartController>(
      builder: (value) => value.items.isEmpty
          ? const EmptyWidget()
          : ListView.builder(
              itemCount: value.items.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.done),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    value.remove(value.items[index]);
                  },
                ),
                title: Text(
                  value.items[index].name,
                  style: itemNameStyle,
                ),
              ),
            ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  final CartController ctrl = Get.find();
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.headline3!.copyWith(fontSize: 48);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetBuilder<CartController>(
              builder: (value) =>
                  Text('\$${value.totalPrice}', style: hugeStyle),
            ),
            const SizedBox(width: 24),
            // TextButton(
            //   onPressed: () async {
            //     await ctrl.makePayment();
            //   },
            //   style: TextButton.styleFrom(primary: Colors.white),
            //   child: const Text('BUY'),
            // ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ))),
                onPressed: () async {
                  await ctrl.makePayment();
                },
                child: Obx(() => ctrl.isProgress.value
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text('Buy')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
