String formatNumber(int number) {
  if (number < 100) return '$number';
  if (number < 1000) return '${(number / 10).round() * 10}';
  if (number < 10000) return '${(number / 100).round() * 100}';
  if (number < 100000) {
    double value = (number / 1000).round() / 10;
    return value == value.toInt() ? '${value.toInt()}만' : '${value}만';
  }
  if (number < 1000000) return '${(number / 10000).round()}만';
  if (number < 10000000) return '${(number / 100000).round() * 10}만';
  if (number < 100000000) return '${(number / 1000000).round() * 100}만';
    return '${(number / 100000000).floor()}억';
}
