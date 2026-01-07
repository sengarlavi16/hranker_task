import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hranker_task/slot_machine/animations/reward_gift.dart';
import 'package:hranker_task/slot_machine/slot_symbol.dart';
import 'reel/reel.dart';

class SlotMachineView extends StatefulWidget {
  const SlotMachineView({super.key});

  @override
  State<SlotMachineView> createState() => _SlotMachineViewState();
}

class _SlotMachineViewState extends State<SlotMachineView> {
  final _reelKey1 = GlobalKey<ReelState>();
  final _reelKey2 = GlobalKey<ReelState>();
  final _reelKey3 = GlobalKey<ReelState>();
  late List<SlotSymbol> _reel1;
  late List<SlotSymbol> _reel2;
  late List<SlotSymbol> _reel3;

  bool _isWin = false;
  List<int> _result = [0, 0, 0];

  void _spin() {
    setState(() {
      _result = [
        pickWeightedIndex(_reel1),
        pickWeightedIndex(_reel2),
        pickWeightedIndex(_reel3),
      ];
      _isWin = false;
    });

    _reelKey1.currentState?.spin();
    _reelKey2.currentState?.spin();
    _reelKey3.currentState?.spin();
  }

  void _onAllFinished() {
    final win = _result[0] == _result[1] && _result[1] == _result[2];
    setState(() => _isWin = win);
  }

  int pickWeightedIndex(List<SlotSymbol> symbols) {
    final totalWeight = symbols.fold<int>(0, (sum, s) => sum + s.weight);

    final rand = Random().nextInt(totalWeight);
    int current = 0;

    for (int i = 0; i < symbols.length; i++) {
      current += symbols[i].weight;
      if (rand < current) return i;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _reel1 = [...slotSymbols]..shuffle();
    _reel2 = [...slotSymbols]..shuffle();
    _reel3 = [...slotSymbols]..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(top: 80, child: RewardGift(show: _isWin)),
              _machine3D(),

              if (_isWin)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                  ),
                ),

              if (_isWin)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.amber.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.9),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _machine3D() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-0.08),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF8FA3),
                  Color(0xFFC93D4E),
                  Color(0xFF7A1F2E),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.9),
                  blurRadius: 60,
                  offset: const Offset(0, 40),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(-8, -8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0E14),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.9),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Reel(
                        key: _reelKey1,
                        stopIndex: _result[0],
                        delay: Duration.zero,
                        symbols: _reel1,
                        onFinished: () {},
                      ),
                      Reel(
                        key: _reelKey2,
                        stopIndex: _result[1],
                        delay: const Duration(milliseconds: 200),
                        symbols: _reel2,
                        onFinished: () {},
                      ),
                      Reel(
                        key: _reelKey3,
                        stopIndex: _result[2],
                        delay: const Duration(milliseconds: 400),
                        symbols: _reel3,
                        onFinished: _onAllFinished,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 320,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF12090C),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.9),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        _spinButton(),
      ],
    );
  }

  Widget _spinButton() {
    return GestureDetector(
      onTap: _spin,
      child: Container(
        width: 180,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE066), Color(0xFFFFB703)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: const Text(
          'SPIN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Color(0xFF6A4B00),
          ),
        ),
      ),
    );
  }
}
