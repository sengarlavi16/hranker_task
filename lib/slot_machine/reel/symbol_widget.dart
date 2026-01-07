import 'dart:ui';
import 'package:flutter/material.dart';
import '../slot_symbol.dart';

class SymbolWidget extends StatelessWidget {
  final int index;
  final double depth;
  final List<SlotSymbol> symbols;

  const SymbolWidget({
    super.key,
    required this.index,
    required this.depth,
    required this.symbols,
  });

  @override
  Widget build(BuildContext context) {
    final scale = lerpDouble(1.0, 0.78, depth)!;
    final opacity = lerpDouble(1.0, 0.55, depth)!;

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 60,
          height: 78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2A2A2A),
                Color(0xFF050505),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.9),
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              symbols[index].icon,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
