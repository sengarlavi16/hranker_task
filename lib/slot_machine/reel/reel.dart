import 'package:flutter/material.dart';
import '../slot_symbol.dart';
import 'symbol_widget.dart';

class Reel extends StatefulWidget {
  final int stopIndex;
  final Duration delay;
  final VoidCallback onFinished;
  final List<SlotSymbol> symbols;

  const Reel({
    super.key,
    required this.stopIndex,
    required this.delay,
    required this.onFinished,
    required this.symbols,
  });

  @override
  ReelState createState() => ReelState();
}

class ReelState extends State<Reel> with SingleTickerProviderStateMixin {
  static const double itemHeight = 80;

  late AnimationController _controller;
  late Animation<double> _offset;

  int get symbolCount => widget.symbols.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _offset = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void spin() async {
    await Future.delayed(widget.delay);

    final total = (symbolCount * 4 + widget.stopIndex) * itemHeight;

    _offset = Tween<double>(
      begin: 0,
      end: total,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    _controller.forward(from: 0).whenComplete(widget.onFinished);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: itemHeight * 3,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final offset = _offset.value % (symbolCount * itemHeight);

                return OverflowBox(
                  minHeight: itemHeight * 3,
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: Offset(0, -offset),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(symbolCount * 2, (i) {
                        final itemCenter =
                            i * itemHeight - offset + itemHeight / 2;

                        final depth =
                            (itemCenter - itemHeight * 1.5).abs() /
                            (itemHeight * 1.5);

                        return SizedBox(
                          height: itemHeight,
                          child: SymbolWidget(
                            index: i % symbolCount,
                            depth: depth.clamp(0, 1),
                            symbols: widget.symbols,
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
          _fade(true),
          _fade(false),
        ],
      ),
    );
  }

  Widget _fade(bool top) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      height: 36,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: top ? Alignment.topCenter : Alignment.bottomCenter,
              end: top ? Alignment.bottomCenter : Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}
