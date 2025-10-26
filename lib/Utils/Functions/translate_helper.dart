import 'package:translator/translator.dart';

class TranslationHelper {
  static final GoogleTranslator _translator = GoogleTranslator();

  static Future<String> translate(String text, String targetLang) async {
    switch (targetLang) {
      case 'hi':
        return translateToHindi(text);
      case 'mr':
        return translateToMarathi(text);
      case 'or':
        return translateToOdia(text);
      case 'en':
        return translateToEnglish(text);
      default:
        return text; // fallback if unsupported
    }
  }

  /// Translate to Hindi
  static Future<String> translateToHindi(String text) async {
    return _translateWithFallback(text, 'hi', _literalTransliterateHindi);
  }

  /// Translate to Marathi
  static Future<String> translateToMarathi(String text) async {
    return _translateWithFallback(text, 'mr', _literalTransliterateMarathi);
  }

  /// Translate to Odia (Oriya)
  static Future<String> translateToOdia(String text) async {
    return _translateWithFallback(text, 'or', _literalTransliterateOdia);
  }

  /// Translate to English
  static Future<String> translateToEnglish(String text) async {
    try {
      var translation = await _translator.translate(
        text,
        from: 'auto',
        to: 'en',
      );
      return translation.text;
    } catch (e) {
      return text;
    }
  }

  /// Generic translation handler with fallback
  static Future<String> _translateWithFallback(
    String text,
    String targetLang,
    String Function(String) fallback,
  ) async {
    try {
      var translation = await _translator.translate(
        text,
        from: 'en',
        to: targetLang,
      );
      String translatedText = translation.text;

      if (_isMostlySame(text, translatedText)) {
        translatedText = fallback(text);
      }

      return translatedText;
    } catch (e) {
      return fallback(text); // fallback to transliteration
    }
  }

  /// Compare if translation didn't actually change
  static bool _isMostlySame(String original, String translated) {
    String o = original.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    String t = translated.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    return o == t;
  }

  /// Hindi fallback (basic mapping in Devanagari)
  static String _literalTransliterateHindi(String text) {
    Map<String, String> mapping = {
      'a': 'ए',
      'b': 'बी',
      'c': 'सी',
      'd': 'डी',
      'e': 'ई',
      'f': 'एफ',
      'g': 'जी',
      'h': 'एच',
      'i': 'आई',
      'j': 'जे',
      'k': 'के',
      'l': 'एल',
      'm': 'एम',
      'n': 'एन',
      'o': 'ओ',
      'p': 'पी',
      'q': 'क्यू',
      'r': 'आर',
      's': 'एस',
      't': 'टी',
      'u': 'यू',
      'v': 'वी',
      'w': 'डब्ल्यू',
      'x': 'एक्स',
      'y': 'वाई',
      'z': 'जेड',
      '0': '०',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };
    return _mapText(text, mapping);
  }

  /// Marathi fallback (same Devanagari script as Hindi, but subtle differences possible)
  static String _literalTransliterateMarathi(String text) {
    // Reuse Hindi map (Marathi uses Devanagari as well)
    return _literalTransliterateHindi(text);
  }

  /// Odia fallback (Odia script)
  static String _literalTransliterateOdia(String text) {
    Map<String, String> mapping = {
      'a': 'ଅ',
      'b': 'ବ',
      'c': 'ସି',
      'd': 'ଡ',
      'e': 'ଇ',
      'f': 'ଫ',
      'g': 'ଗ',
      'h': 'ହ',
      'i': 'ଇ',
      'j': 'ଜ',
      'k': 'କ',
      'l': 'ଲ',
      'm': 'ମ',
      'n': 'ନ',
      'o': 'ଓ',
      'p': 'ପ',
      'q': 'କ୍ୟୁ',
      'r': 'ର',
      's': 'ସ',
      't': 'ଟ',
      'u': 'ଉ',
      'v': 'ଭି',
      'w': 'ଡବଲ୍ୟୁ',
      'x': 'ଏକ୍ସ',
      'y': 'ଯ',
      'z': 'ଜେଡ୍',
      '0': '୦',
      '1': '୧',
      '2': '୨',
      '3': '୩',
      '4': '୪',
      '5': '୫',
      '6': '୬',
      '7': '୭',
      '8': '୮',
      '9': '୯',
    };
    return _mapText(text, mapping);
  }

  /// Helper to apply character mapping
  static String _mapText(String text, Map<String, String> mapping) {
    StringBuffer result = StringBuffer();
    for (var char in text.split('')) {
      String lower = char.toLowerCase();
      if (mapping.containsKey(lower)) {
        result.write(mapping[lower]);
      } else {
        result.write(char);
      }
    }
    return result.toString();
  }
}
