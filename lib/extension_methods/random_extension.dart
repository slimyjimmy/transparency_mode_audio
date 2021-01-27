import 'dart:math';

extension RandomExtension on Random {
  int nextIntInRange(int min, int max) =>
      min + (this.nextDouble() * max).round();
}
