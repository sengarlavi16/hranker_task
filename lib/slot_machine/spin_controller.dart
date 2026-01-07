import 'dart:math';

class SpinController {
  /// Determines final reel positions
  List<int> generateResult() {
    final random = Random();
    return List.generate(3, (_) => random.nextInt(6));
  }

  bool isWin(List<int> result) {
    return result.every((i) => i == result.first);
  }
}
