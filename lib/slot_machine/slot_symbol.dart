import 'package:flutter/material.dart';

class SlotSymbol {
  final IconData icon;
  final int weight;

  const SlotSymbol(this.icon, this.weight);
}

const List<SlotSymbol> slotSymbols = [
  SlotSymbol(Icons.circle, 40),
  SlotSymbol(Icons.star, 25),
  SlotSymbol(Icons.favorite, 15),
  SlotSymbol(Icons.diamond, 10),
  SlotSymbol(Icons.catching_pokemon, 7),
  SlotSymbol(Icons.bolt, 13),
];
