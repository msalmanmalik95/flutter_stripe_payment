import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/controller/cart_controller.dart';
import 'package:stripe_payment/model/catalog_model.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final controller = Get.put(CatalogController());
  final ctrl = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Obx(() => ctrl.items.isEmpty
                ? IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  )
                : Badge(
                    badgeContent: Text(
                      '${ctrl.items.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    position: BadgePosition.topEnd(top: 0.0, end: 0.0),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                  )),
          ),
        ],
      ),
      body: _MyListItem(),
    );
  }
}

class _MyListItem extends StatelessWidget {
  _MyListItem({Key? key}) : super(key: key);
  final CatalogController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.headline6;

    return ListView.builder(
      itemCount: ctrl.items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LimitedBox(
            maxHeight: 48,
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ctrl.items[index].color,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(ctrl.items[index].name, style: textTheme),
                ),
                const SizedBox(width: 24),
                _AddButton(item: ctrl.items[index]),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddButton extends StatelessWidget {
  final CartController ctrl = Get.find();

  final Item item;

  _AddButton({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextButton(
          onPressed: ctrl.items.contains(item)
              ? () => {ctrl.remove(item)}
              : () => {ctrl.add(item)},
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme.of(context).primaryColor;
              }
              return null;
            }),
          ),
          child: ctrl.items.contains(item)
              ? const Icon(Icons.check, semanticLabel: 'ADDED')
              : const Text('ADD'),
        ));
  }
}
