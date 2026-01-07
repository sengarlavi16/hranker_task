import 'package:flutter/material.dart';

class RewardGift extends StatefulWidget {
  final bool show;

  const RewardGift({super.key, required this.show});

  @override
  State<RewardGift> createState() => _RewardGiftState();
}

class _RewardGiftState extends State<RewardGift>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slide = Tween<double>(
      begin: -40,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant RewardGift oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _controller.reset(); // VERY IMPORTANT
      _controller.forward(); // now first spin works
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _slide.value),
          child: Transform.scale(scale: _scale.value, child: _giftBody()),
        );
      },
    );
  }

  Widget _giftBody() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE29A), Color(0xFFFFC857)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.9),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: const Icon(
        Icons.card_giftcard,
        size: 42,
        color: Color(0xFF6A4B00),
      ),
    );
  }
}
