import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(title: const Text('Payment')),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            itemData(
                onTap: () => onClickRoute(routeName: '/catalog'),
                title: 'Stripe',
                icon: FontAwesomeIcons.stripe),
            const SizedBox(height: 16.0),
            itemData(
                onTap: () => onClickRoute(routeName: '/catalog'),
                title: 'Apple Pay',
                icon: FontAwesomeIcons.applePay),
            const SizedBox(height: 16.0),
            itemData(
              onTap: () => onClickRoute(routeName: '/catalog'),
              title: 'Google Pay',
              icon: FontAwesomeIcons.googlePay,
            ),
          ],
        ),
      ),
    );
  }

  Widget itemData(
      {required String title,
      required Function onTap,
      required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () => onTap(),
        title: Icon(
          icon,
          size: 50,
        ),
        // title: Text(
        //   title,
        //   style: const TextStyle(
        //     fontSize: 20,
        //     wordSpacing: 4,
        //   ),
        // ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),
      ),
    );
  }

  /// CLick Listener
  void onClickRoute({required String routeName}) {
    Navigator.pushNamed(context, routeName);
  }
}
