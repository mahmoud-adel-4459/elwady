/// Helper utility for Arabic digits and numerals
class ArabicNumbers {
  static const Map<String, String> _englishToArabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  static String convert(dynamic input) {
    if (input == null) return '';
    final str = input.toString();
    var result = '';
    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      result += _englishToArabicDigits[char] ?? char;
    }
    return result;
  }
}
