import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatalogController extends GetxController {
  final items = <Item>[].obs;

  @override
  void onInit() {
    getItemsList();
    super.onInit();
  }

  static List<String> itemNames = [
    'Code Smell',
    'Control Flow',
    'Interpreter',
    'Recursion',
    'Sprint',
    'Heisenbug',
    'Spaghetti',
    'Hydra Code',
    'Off-By-One',
    'Scope',
    'Callback',
    'Closure',
    'Automata',
    'Bit Shift',
    'Currying',
  ];

  Item getById(int id) => Item(id: id, name: itemNames[id % itemNames.length]);

  Item getByPosition(int position) {
    return getById(position);
  }

  void getItemsList() {
    List<Item> itemTemp = [];
    for (int i = 0; i < itemNames.length; i++) {
      itemTemp.add(getByPosition(i));
    }
    items.addAll(itemTemp);
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final Color color;
  int price = 42;

  Item({required this.id, required this.name, this.price = 42})
      : color = Colors.primaries[id % Colors.primaries.length];

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}
