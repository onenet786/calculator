import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

const String _divideSymbol = '\u00F7';
const String _multiplySymbol = '\u00D7';
const String _appName = 'Rainbow Calculator';
const String _appVersion = '1.0.0+1';
const String _appIconAsset = 'assets/app_icon/classic_kid_icon.png';
const String _poweredByShort = 'Powered by OneNet Solutions Pakistan.';
const String _poweredByLong = 'Powered by OneNet Solutions Pakistan';
const Map<int, String> _romanUrduNumbers = {
  0: 'sifar',
  1: 'aik',
  2: 'do',
  3: 'teen',
  4: 'chaar',
  5: 'paanch',
  6: 'chay',
  7: 'saat',
  8: 'aath',
  9: 'nau',
  10: 'das',
  11: 'gyarah',
  12: 'barah',
  13: 'terah',
  14: 'chaudah',
  15: 'pandrah',
  16: 'solah',
  17: 'satrah',
  18: 'atharah',
  19: 'unnees',
  20: 'bees',
  21: 'ikkees',
  22: 'baees',
  23: 'taees',
  24: 'chaubees',
  25: 'pachees',
  26: 'chhabbees',
  27: 'sattaees',
  28: 'atthaees',
  29: 'untees',
  30: 'tees',
  31: 'iktees',
  32: 'battees',
  33: 'tentees',
  34: 'chauntees',
  35: 'paintees',
  36: 'chhattees',
  37: 'saintees',
  38: 'artees',
  39: 'untalees',
  40: 'chaalees',
  41: 'iktalees',
  42: 'bayalees',
  43: 'taintalees',
  44: 'chawalees',
  45: 'paintalees',
  46: 'chiyalees',
  47: 'saintalees',
  48: 'artalees',
  49: 'unchaas',
  50: 'pachaas',
  51: 'ikyaavan',
  52: 'baavan',
  53: 'tirpan',
  54: 'chauvan',
  55: 'pachpan',
  56: 'chhappan',
  57: 'sattaavan',
  58: 'atthaavan',
  59: 'unsath',
  60: 'saath',
  61: 'iksath',
  62: 'basath',
  63: 'tirsath',
  64: 'chaunsath',
  65: 'painsath',
  66: 'chhiyaasath',
  67: 'sarsath',
  68: 'arsath',
  69: 'unhattar',
  70: 'sattar',
  71: 'ikhattar',
  72: 'bahattar',
  73: 'tihattar',
  74: 'chauhattar',
  75: 'pachhattar',
  76: 'chhihattar',
  77: 'sathattar',
  78: 'atthattar',
  79: 'unasi',
  80: 'assi',
  81: 'ikyasi',
  82: 'bayasi',
  83: 'tirasi',
  84: 'chaurasi',
  85: 'pachasi',
  86: 'chhiyasi',
  87: 'sattasi',
  88: 'atthasi',
  89: 'navasi',
  90: 'naway',
  91: 'ikyanaway',
  92: 'banaway',
  93: 'tiranaway',
  94: 'chauranaway',
  95: 'pachaanaway',
  96: 'chhiyanaway',
  97: 'sattanaway',
  98: 'atthanaway',
  99: 'ninnanaway',
  100: 'sau',
};
const Map<int, String> _urduNumbers = {
  0: 'صفر',
  1: 'ایک',
  2: 'دو',
  3: 'تین',
  4: 'چار',
  5: 'پانچ',
  6: 'چھ',
  7: 'سات',
  8: 'آٹھ',
  9: 'نو',
  10: 'دس',
  11: 'گیارہ',
  12: 'بارہ',
  13: 'تیرہ',
  14: 'چودہ',
  15: 'پندرہ',
  16: 'سولہ',
  17: 'سترہ',
  18: 'اٹھارہ',
  19: 'انیس',
  20: 'بیس',
  21: 'اکیس',
  22: 'بائیس',
  23: 'تئیس',
  24: 'چوبیس',
  25: 'پچیس',
  26: 'چھبیس',
  27: 'ستائیس',
  28: 'اٹھائیس',
  29: 'انتیس',
  30: 'تیس',
  31: 'اکتیس',
  32: 'بتیس',
  33: 'تینتیس',
  34: 'چونتیس',
  35: 'پینتیس',
  36: 'چھتیس',
  37: 'سینتیس',
  38: 'اڑتیس',
  39: 'انتالیس',
  40: 'چالیس',
  41: 'اکتالیس',
  42: 'بیالیس',
  43: 'تینتالیس',
  44: 'چوالیس',
  45: 'پینتالیس',
  46: 'چھیالیس',
  47: 'سنتالیس',
  48: 'اڑتالیس',
  49: 'انچاس',
  50: 'پچاس',
  51: 'اکاون',
  52: 'باون',
  53: 'ترپن',
  54: 'چون',
  55: 'پچپن',
  56: 'چھپن',
  57: 'ستاون',
  58: 'اٹھاون',
  59: 'انسٹھ',
  60: 'ساٹھ',
  61: 'اکسٹھ',
  62: 'باسٹھ',
  63: 'تریسٹھ',
  64: 'چونسٹھ',
  65: 'پینسٹھ',
  66: 'چھاسٹھ',
  67: 'سڑسٹھ',
  68: 'اڑسٹھ',
  69: 'انہتر',
  70: 'ستر',
  71: 'اکہتر',
  72: 'بہتر',
  73: 'تہتر',
  74: 'چوہتر',
  75: 'پچھتر',
  76: 'چھہتر',
  77: 'ستتر',
  78: 'اٹھتر',
  79: 'اناسی',
  80: 'اسی',
  81: 'اکیاسی',
  82: 'بیاسی',
  83: 'تراسی',
  84: 'چوراسی',
  85: 'پچاسی',
  86: 'چھیاسی',
  87: 'ستاسی',
  88: 'اٹھاسی',
  89: 'نواسی',
  90: 'نوے',
  91: 'اکیانوے',
  92: 'بانوے',
  93: 'ترانوے',
  94: 'چورانوے',
  95: 'پچانوے',
  96: 'چھیانوے',
  97: 'ستانوے',
  98: 'اٹھانوے',
  99: 'ننانوے',
  100: 'سو',
};

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC857),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterTts _splashSpeaker = FlutterTts();

  @override
  void initState() {
    super.initState();
    unawaited(_speakLoadingMessage());
    Future<void>.delayed(const Duration(milliseconds: 4500), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CalculatorScreen()),
      );
    });
  }

  @override
  void dispose() {
    _splashSpeaker.stop();
    super.dispose();
  }

  Future<void> _speakLoadingMessage() async {
    try {
      await _splashSpeaker.setLanguage('en-US');
      await _splashSpeaker.setSpeechRate(0.38);
      await _splashSpeaker.setPitch(1.2);
      await _splashSpeaker.setVolume(1);
      await _splashSpeaker.speak(
        'Loading Rainbow Calculator by OneNet Solutions',
      );
    } catch (_) {
      // TTS engines are not available in all test environments.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF4B8), Color(0xFFCFF3FF), Color(0xFFFFD3F0)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 42,
                left: 28,
                child: _SplashBubble(color: Color(0xFFFFC857), size: 70),
              ),
              const Positioned(
                right: 34,
                top: 92,
                child: _SplashBubble(color: Color(0xFF06D6A0), size: 44),
              ),
              const Positioned(
                bottom: 110,
                left: 46,
                child: _SplashBubble(color: Color(0xFFFF6B6B), size: 52),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 174,
                        height: 174,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(44),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 36,
                              color: Color(0x26000000),
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(34),
                          child: Image.asset(_appIconAsset, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        _appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF243B53),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        _poweredByLong,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF5C677D),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const SizedBox(
                        width: 110,
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          borderRadius: BorderRadius.all(Radius.circular(99)),
                          backgroundColor: Colors.white,
                          color: Color(0xFFFF6B6B),
                        ),
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
}

class _SplashBubble extends StatelessWidget {
  const _SplashBubble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.32),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  static const List<_ButtonSpec> _buttons = [
    _ButtonSpec('AC', Color(0xFFFF6B6B), Color(0xFFFFD1D1), 0),
    _ButtonSpec('+/-', Color(0xFF845EC2), Color(0xFFE3D4FF), 1),
    _ButtonSpec('%', Color(0xFFFFB000), Color(0xFFFFE8A3), 2),
    _ButtonSpec(_divideSymbol, Color(0xFF009EFA), Color(0xFFC7EFFF), 3),
    _ButtonSpec('7', Color(0xFFFF9671), Color(0xFFFFD8C9), 4),
    _ButtonSpec('8', Color(0xFF00C9A7), Color(0xFFC9FFF5), 5),
    _ButtonSpec('9', Color(0xFFFF8066), Color(0xFFFFD2C9), 6),
    _ButtonSpec(_multiplySymbol, Color(0xFF4D96FF), Color(0xFFD5E7FF), 7),
    _ButtonSpec('4', Color(0xFF7BC043), Color(0xFFE3F7D3), 8),
    _ButtonSpec('5', Color(0xFFFFC75F), Color(0xFFFFE9B8), 9),
    _ButtonSpec('6', Color(0xFFB39CD0), Color(0xFFECE2FF), 10),
    _ButtonSpec('-', Color(0xFFFF5E78), Color(0xFFFFD0D8), 11),
    _ButtonSpec('1', Color(0xFF2EC4B6), Color(0xFFCEFFF8), 12),
    _ButtonSpec('2', Color(0xFFFF9F1C), Color(0xFFFFE0AC), 13),
    _ButtonSpec('3', Color(0xFF9B5DE5), Color(0xFFE6D4FF), 14),
    _ButtonSpec('+', Color(0xFF00BBF9), Color(0xFFCFF3FF), 15),
    _ButtonSpec('.', Color(0xFF577590), Color(0xFFDCE9F1), 16),
    _ButtonSpec('0', Color(0xFF43AA8B), Color(0xFFD5F5E9), 17),
    _ButtonSpec('MR', Color(0xFFF15BB5), Color(0xFFFFD3F0), 18),
    _ButtonSpec('=', Color(0xFF06D6A0), Color(0xFFC9FFEF), 19),
  ];

  String _expression = '0';
  String _display = '0';
  double _memory = 0;
  bool _isError = false;
  bool _replaceOnNextDigit = false;
  bool _speakUrdu = true;
  String? _lastAnswerValue;
  bool _isCountingSequenceActive = false;
  bool _isTableSequenceActive = false;
  int? _activeTableNumber;
  int? _activeTableLine;
  int? _activeCountingNumber;
  bool _isListeningForCommand = false;
  bool _isRetryingSpeechListen = false;
  String _voiceCommandStatus = 'Tap mic and say table or counting';
  final List<_CalculationRecord> _history = [];
  final FlutterTts _speaker = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    unawaited(_setupSpeaker());
  }

  @override
  void dispose() {
    _speech.stop();
    _speaker.stop();
    super.dispose();
  }

  void _buttonPressed(String value) {
    if (value != '=') {
      unawaited(_speakButton(value));
    }

    setState(() {
      if (value == 'AC') {
        _expression = '0';
        _display = '0';
        _isError = false;
        _replaceOnNextDigit = false;
        return;
      }

      if (value == 'MR') {
        _expression = _formatNumber(_memory);
        _display = _expression;
        _isError = false;
        _replaceOnNextDigit = true;
        return;
      }

      if (value == '+/-') {
        _toggleSign();
        return;
      }

      if (value == '%') {
        _applyPercent();
        return;
      }

      if (value == '=') {
        _evaluate();
        return;
      }

      if (_isOperator(value)) {
        _appendOperator(value);
        return;
      }

      _appendDigitOrDecimal(value);
    });
  }

  Future<void> _setupSpeaker() async {
    await _speaker.setLanguage(
      _useRomanUrdu ? 'en-US' : (_speakUrdu ? 'ur-PK' : 'en-US'),
    );
    await _speaker.setSpeechRate(0.42);
    await _speaker.setPitch(1.25);
    await _speaker.setVolume(1);
    await _speaker.awaitSpeakCompletion(false);
  }

  bool get _useRomanUrdu => kIsWeb && _speakUrdu;

  Future<void> _toggleSpeechLanguage() async {
    setState(() {
      _speakUrdu = !_speakUrdu;
    });
    await _setupSpeaker();
    unawaited(_speak(_speakUrdu ? 'اردو' : 'English'));
  }

  Future<void> _speakButton(String value) async {
    await _speak(_spokenLabelForSpeech(value));
  }

  Future<void> _speak(String text) async {
    if (text.contains('\u00d8') ||
        text.startsWith('equals ') ||
        text == 'try again') {
      return;
    }

    if (text.contains('Ø') ||
        text.startsWith('equals ') ||
        text == 'try again') {}

    try {
      await _speaker.stop();
      await _speaker.speak(text);
    } catch (_) {
      // TTS engines are not available in all test environments.
    }
  }

  Future<void> _stopSpeakerSafely() async {
    try {
      await _speaker.stop().timeout(
        const Duration(milliseconds: 500),
        onTimeout: () => 0,
      );
    } catch (_) {
      // TTS engines are not available in all test environments.
    }
  }

  // ignore: unused_element
  String _spokenLabel(String value) {
    if (_speakUrdu) {
      return switch (value) {
        '0' => 'صفر',
        '1' => 'ایک',
        '2' => 'دو',
        '3' => 'تین',
        '4' => 'چار',
        '5' => 'پانچ',
        '6' => 'چھ',
        '7' => 'سات',
        '8' => 'آٹھ',
        '9' => 'نو',
        'AC' => 'صاف',
        '+/-' => 'جمع منفی',
        '%' => 'فیصد',
        _divideSymbol => 'تقسیم',
        _multiplySymbol => 'ضرب',
        '-' => 'منفی',
        '+' => 'جمع',
        '.' => 'اعشاریہ',
        'MR' => 'میموری',
        '=' => 'برابر',
        _ => value,
      };
    }

    return switch (value) {
      '0' => 'zero',
      '1' => 'one',
      '2' => 'two',
      '3' => 'three',
      '4' => 'four',
      '5' => 'five',
      '6' => 'six',
      '7' => 'seven',
      '8' => 'eight',
      '9' => 'nine',
      'AC' => 'clear',
      '+/-' => 'plus minus',
      '%' => 'percent',
      _divideSymbol => 'divide',
      _multiplySymbol => 'multiply',
      '-' => 'minus',
      '+' => 'plus',
      '.' => 'point',
      'MR' => 'memory',
      '=' => 'equals',
      _ => value,
    };
  }

  String _spokenLabelForSpeech(String value) {
    if (_useRomanUrdu) {
      return switch (value) {
        '0' => 'sifar',
        '1' => 'aik',
        '2' => 'do',
        '3' => 'teen',
        '4' => 'chaar',
        '5' => 'paanch',
        '6' => 'chay',
        '7' => 'saat',
        '8' => 'aath',
        '9' => 'nau',
        'AC' => 'saaf',
        '+/-' => 'jamaa manfi',
        '%' => 'feesad',
        _divideSymbol => 'taqseem',
        _multiplySymbol => 'zarb',
        '-' => 'manfi',
        '+' => 'jamaa',
        '.' => 'aashariya',
        'MR' => 'memory',
        '=' => 'barabar',
        _ => value,
      };
    }

    if (_speakUrdu) {
      return switch (value) {
        '0' => '\u0635\u0641\u0631',
        '1' => '\u0627\u06cc\u06a9',
        '2' => '\u062f\u0648',
        '3' => '\u062a\u06cc\u0646',
        '4' => '\u0686\u0627\u0631',
        '5' => '\u067e\u0627\u0646\u0686',
        '6' => '\u0686\u06be',
        '7' => '\u0633\u0627\u062a',
        '8' => '\u0622\u0679\u06be',
        '9' => '\u0646\u0648',
        'AC' => '\u0635\u0627\u0641',
        '+/-' => '\u062c\u0645\u0639 \u0645\u0646\u0641\u06cc',
        '%' => '\u0641\u06cc\u0635\u062f',
        _divideSymbol => '\u062a\u0642\u0633\u06cc\u0645',
        _multiplySymbol => '\u0636\u0631\u0628',
        '-' => '\u0645\u0646\u0641\u06cc',
        '+' => '\u062c\u0645\u0639',
        '.' => '\u0627\u0639\u0634\u0627\u0631\u06cc\u06c1',
        'MR' => '\u0645\u06cc\u0645\u0648\u0631\u06cc',
        '=' => '\u0628\u0631\u0627\u0628\u0631',
        _ => value,
      };
    }

    return switch (value) {
      '0' => 'zero',
      '1' => 'one',
      '2' => 'two',
      '3' => 'three',
      '4' => 'four',
      '5' => 'five',
      '6' => 'six',
      '7' => 'seven',
      '8' => 'eight',
      '9' => 'nine',
      'AC' => 'clear',
      '+/-' => 'plus minus',
      '%' => 'percent',
      _divideSymbol => 'divide',
      _multiplySymbol => 'multiply',
      '-' => 'minus',
      '+' => 'plus',
      '.' => 'point',
      'MR' => 'memory',
      '=' => 'equals',
      _ => value,
    };
  }

  String _answerSpeech(String answer) {
    if (_useRomanUrdu) {
      return 'jawab ${_spokenNumber(answer)}';
    }

    return _speakUrdu
        ? '\u062c\u0648\u0627\u0628 ${_spokenNumber(answer)}'
        : 'answer ${_spokenNumber(answer)}';
  }

  String _calculationSpeech(String expression, String answer) {
    final spokenExpression = _expressionTokens(expression)
        .map((part) => _spokenExpressionToken(part))
        .join(' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (_useRomanUrdu) {
      return '$spokenExpression. jawab ${_spokenNumber(answer)}';
    }

    return _speakUrdu
        ? '$spokenExpression. \u062c\u0648\u0627\u0628 ${_spokenNumber(answer)}'
        : '$spokenExpression. answer ${_spokenNumber(answer)}';
  }

  List<String> _expressionTokens(String expression) {
    return RegExp(
      r'-?\d+(?:\.\d+)?|[+\-×÷%]',
    ).allMatches(expression).map((match) => match.group(0)!).toList();
  }

  String _spokenExpressionToken(String token) {
    if (RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(token)) {
      return _spokenNumber(token);
    }

    return _spokenLabelForSpeech(token);
  }

  String _spokenNumber(String value) {
    if (value.startsWith('-')) {
      final number = _spokenNumber(value.substring(1));
      return _speakUrdu || _useRomanUrdu
          ? '${_spokenLabelForSpeech('-')} $number'
          : 'minus $number';
    }

    if (value.contains('.')) {
      final parts = value.split('.');
      final fraction = parts[1].split('').map(_spokenLabelForSpeech).join(' ');
      return '${_spokenNumber(parts[0])} ${_spokenLabelForSpeech('.')} $fraction';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return value;
    }

    if (_useRomanUrdu) {
      return _spokenIntegerRomanUrdu(number);
    }

    if (_speakUrdu) {
      return _spokenIntegerUrdu(number);
    }

    return _spokenIntegerEnglish(number);
  }

  String _spokenIntegerEnglish(int number) {
    const ones = [
      'zero',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];
    const tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];

    if (number < 20) {
      return ones[number];
    }
    if (number < 100) {
      final rest = number % 10;
      return rest == 0
          ? tens[number ~/ 10]
          : '${tens[number ~/ 10]} ${ones[rest]}';
    }
    if (number < 1000) {
      final rest = number % 100;
      final hundred = '${ones[number ~/ 100]} hundred';
      return rest == 0 ? hundred : '$hundred ${_spokenIntegerEnglish(rest)}';
    }
    if (number < 1000000) {
      final rest = number % 1000;
      final thousand = '${_spokenIntegerEnglish(number ~/ 1000)} thousand';
      return rest == 0 ? thousand : '$thousand ${_spokenIntegerEnglish(rest)}';
    }

    return number.toString();
  }

  String _spokenIntegerRomanUrdu(int number) {
    if (number <= 100) {
      return _romanUrduNumbers[number] ?? number.toString();
    }
    if (number < 1000) {
      final rest = number % 100;
      final hundred = '${_romanUrduNumbers[number ~/ 100]} sau';
      return rest == 0 ? hundred : '$hundred ${_spokenIntegerRomanUrdu(rest)}';
    }
    if (number < 100000) {
      final rest = number % 1000;
      final thousand = '${_spokenIntegerRomanUrdu(number ~/ 1000)} hazaar';
      return rest == 0
          ? thousand
          : '$thousand ${_spokenIntegerRomanUrdu(rest)}';
    }

    return number.toString();
  }

  String _spokenIntegerUrdu(int number) {
    if (number <= 100) {
      return _urduNumbers[number] ?? number.toString();
    }
    if (number < 1000) {
      final rest = number % 100;
      final hundred = '${_urduNumbers[number ~/ 100]} \u0633\u0648';
      return rest == 0 ? hundred : '$hundred ${_spokenIntegerUrdu(rest)}';
    }
    if (number < 100000) {
      final rest = number % 1000;
      final thousand =
          '${_spokenIntegerUrdu(number ~/ 1000)} \u06c1\u0632\u0627\u0631';
      return rest == 0 ? thousand : '$thousand ${_spokenIntegerUrdu(rest)}';
    }

    return number.toString();
  }

  String _tryAgainSpeech() {
    if (_useRomanUrdu) {
      return 'dobara koshish karein';
    }

    return _speakUrdu
        ? '\u062f\u0648\u0628\u0627\u0631\u06c1 \u06a9\u0648\u0634\u0634 \u06a9\u0631\u06cc\u06ba'
        : 'please try again';
  }

  String _aboutSpeech() {
    if (_useRomanUrdu) {
      return 'Rainbow Calculator. Version $_appVersion. Powered by OneNet Solutions Pakistan.';
    }

    return _speakUrdu
        ? '\u0631\u06cc\u0646\u0628\u0648 \u06a9\u06cc\u0644\u06a9\u0648\u0644\u06cc\u0679\u0631. \u0648\u0631\u0698\u0646 $_appVersion. \u067e\u0627\u0648\u0631\u0688 \u0628\u0627\u0626\u06cc \u0648\u0646 \u0646\u06cc\u0679 \u0633\u0648\u0644\u0648\u0634\u0646\u0632 \u067e\u0627\u06a9\u0633\u062a\u0627\u0646.'
        : '$_appName. Version $_appVersion. $_poweredByShort';
  }

  void _repeatLastAnswer() {
    final value = _lastAnswerValue;
    if (value == null) {
      unawaited(
        _speak(
          _speakUrdu
              ? '\u067e\u06c1\u0644\u06d2 \u062d\u0633\u0627\u0628 \u06a9\u0631\u06cc\u06ba'
              : 'calculate first',
        ),
      );
      return;
    }
    unawaited(_speak(_answerSpeech(value)));
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
    unawaited(
      _speak(
        _speakUrdu
            ? '\u06c1\u0633\u0679\u0631\u06cc \u0635\u0627\u0641'
            : 'history cleared',
      ),
    );
  }

  Future<void> _speakTable(int number) async {
    setState(() {
      _isCountingSequenceActive = false;
      _isTableSequenceActive = true;
      _activeCountingNumber = null;
      _activeTableNumber = number;
      _activeTableLine = null;
    });
    await _stopSpeakerSafely();

    final tableName = '${_spokenNumber(number.toString())} table';
    unawaited(_speak(tableName));
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    for (var index = 0; index < 10; index++) {
      if (!mounted || !_isTableSequenceActive || _activeTableNumber != number) {
        return;
      }
      final multiplier = index + 1;
      final answer = number * multiplier;
      final line = _speakUrdu || _useRomanUrdu
          ? '${_spokenNumber(number.toString())} ${_spokenLabelForSpeech(_multiplySymbol)} ${_spokenNumber(multiplier.toString())} ${_spokenLabelForSpeech('=')} ${_spokenNumber(answer.toString())}'
          : '$number times $multiplier equals $answer';
      setState(() {
        _activeTableLine = multiplier;
      });
      unawaited(_speak(line));
      await Future<void>.delayed(const Duration(milliseconds: 2400));
    }

    if (!mounted || !_isTableSequenceActive || _activeTableNumber != number) {
      return;
    }
    setState(() {
      _isTableSequenceActive = false;
      _activeTableNumber = null;
      _activeTableLine = null;
    });
  }

  Future<void> _startCountingSpeech() async {
    setState(() {
      _isCountingSequenceActive = true;
      _isTableSequenceActive = false;
      _activeTableNumber = null;
      _activeTableLine = null;
      _activeCountingNumber = null;
    });
    await _stopSpeakerSafely();
    await _speakCountingBlock(1);
  }

  Future<void> _speakCountingBlock(int start) async {
    if (!_isCountingSequenceActive || !mounted) {
      return;
    }

    final end = (start + 9).clamp(1, 100);
    for (var number = start; number <= end; number++) {
      if (!_isCountingSequenceActive || !mounted) {
        return;
      }
      setState(() {
        _activeCountingNumber = number;
      });
      unawaited(_speak(_spokenNumber(number.toString())));
      await Future<void>.delayed(const Duration(milliseconds: 800));
    }

    if (!_isCountingSequenceActive || !mounted || end >= 100) {
      setState(() {
        _isCountingSequenceActive = false;
        _activeCountingNumber = null;
      });
      return;
    }

    unawaited(
      _speak(
        _speakUrdu || _useRomanUrdu
            ? 'گنتی جاری رکھنا چاہتے ہیں؟'
            : 'continue counting?',
      ),
    );

    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isUrduPrompt = _speakUrdu || _useRomanUrdu;
        final urduButtonStyle = isUrduPrompt
            ? const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)
            : null;
        return AlertDialog(
          title: Text(
            isUrduPrompt ? 'گنتی جاری رکھنا چاہتے ہیں؟' : 'Continue counting?',
          ),
          content: Text('$start - $end complete'),
          actions: [
            TextButton(
              key: const ValueKey('cancel-counting'),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                isUrduPrompt ? 'نہیں' : 'Cancel',
                style: urduButtonStyle,
              ),
            ),
            FilledButton(
              key: const ValueKey('continue-counting'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                isUrduPrompt ? 'ہاں' : 'Continue',
                style: urduButtonStyle,
              ),
            ),
          ],
        );
      },
    );

    if (shouldContinue == true) {
      await _speakCountingBlock(end + 1);
      return;
    }

    setState(() {
      _isCountingSequenceActive = false;
      _activeCountingNumber = null;
    });
    await _stopSpeakerSafely();
  }

  void _stopLearningSpeech() {
    setState(() {
      _isCountingSequenceActive = false;
      _isTableSequenceActive = false;
      _activeTableNumber = null;
      _activeTableLine = null;
      _activeCountingNumber = null;
    });
    unawaited(_stopSpeakerSafely());
  }

  Future<void> _listenForLearningCommand() async {
    if (_isListeningForCommand) {
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListeningForCommand = false;
          _voiceCommandStatus = 'Tap mic and say table or counting';
        });
      }
      return;
    }

    try {
      await _stopSpeakerSafely();
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) {
            return;
          }
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListeningForCommand = false;
            });
          }
        },
        onError: (error) {
          if (!mounted) {
            return;
          }
          if (error.errorMsg == 'error_network') {
            setState(() {
              _isListeningForCommand = false;
              _voiceCommandStatus =
                  'Network speech failed. Trying offline speech...';
            });
            if (!_isRetryingSpeechListen) {
              _isRetryingSpeechListen = true;
              unawaited(_startSpeechCommandListen(onDeviceOnly: true));
            }
            return;
          }
          setState(() {
            _isListeningForCommand = false;
            _voiceCommandStatus = error.permanent
                ? 'Speech unavailable: ${error.errorMsg}'
                : 'Could not hear: ${error.errorMsg}';
          });
        },
      );

      if (!available) {
        if (!mounted) {
          return;
        }
        setState(() {
          _voiceCommandStatus =
              'Speech service unavailable${_speechServiceHint()}';
        });
        unawaited(
          _speak(
            _speakUrdu
                ? 'اس ڈیوائس پر آواز کی پہچان دستیاب نہیں'
                : 'speech recognition is not available on this device',
          ),
        );
        return;
      }

      final localeId = await _preferredSpeechLocale();
      setState(() {
        _isListeningForCommand = true;
        _isRetryingSpeechListen = false;
        _voiceCommandStatus = _speakUrdu
            ? 'بولیں: ٹیبل یا گنتی'
            : 'Say: read table 2 or counting';
      });

      await _startSpeechCommandListen(localeId: localeId);
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isListeningForCommand = false;
        _voiceCommandStatus =
            'Speech service unavailable${_speechServiceHint()}';
      });
    }
  }

  Future<void> _startSpeechCommandListen({
    String? localeId,
    bool onDeviceOnly = false,
  }) async {
    final listenLocale = localeId ?? await _preferredSpeechLocale();
    if (!mounted) {
      return;
    }
    setState(() {
      _isListeningForCommand = true;
      _voiceCommandStatus = onDeviceOnly
          ? 'Listening offline: say table or counting'
          : _voiceCommandStatus;
    });

    // ignore: deprecated_member_use
    await _speech.listen(
      // ignore: deprecated_member_use
      localeId: listenLocale,
      // ignore: deprecated_member_use
      listenFor: const Duration(seconds: 6),
      // ignore: deprecated_member_use
      pauseFor: const Duration(seconds: 2),
      listenOptions: stt.SpeechListenOptions(
        partialResults: false,
        onDevice: onDeviceOnly,
        cancelOnError: false,
      ),
      onResult: (result) {
        if (!result.finalResult) {
          return;
        }
        final command = result.recognizedWords.trim();
        if (command.isEmpty) {
          return;
        }
        unawaited(_handleLearningCommand(command));
      },
    );
  }

  String _speechServiceHint() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '. Install or enable Speech Services by Google';
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return '. Enable Windows speech recognition and microphone privacy';
    }
    return '';
  }

  Future<String?> _preferredSpeechLocale() async {
    try {
      final locales = await _speech.locales();
      final preferredPrefixes = _speakUrdu
          ? const ['ur_', 'ur-', 'en_US', 'en-']
          : const ['en_US', 'en-'];
      for (final prefix in preferredPrefixes) {
        for (final locale in locales) {
          if (locale.localeId.startsWith(prefix)) {
            return locale.localeId;
          }
        }
      }
      final systemLocale = await _speech.systemLocale();
      return systemLocale?.localeId;
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleLearningCommand(String command) async {
    await _speech.stop();
    if (!mounted) {
      return;
    }
    setState(() {
      _isListeningForCommand = false;
      _voiceCommandStatus = command;
    });

    final normalized = command.toLowerCase();
    if (normalized.contains('count') ||
        normalized.contains('ginti') ||
        command.contains('گنتی')) {
      await _startCountingSpeech();
      return;
    }

    final tableNumber = _numberFromLearningCommand(command);
    if (tableNumber != null) {
      await _speakTable(tableNumber);
      return;
    }

    unawaited(
      _speak(
        _speakUrdu
            ? 'براہ کرم ٹیبل یا گنتی کہیں'
            : 'please say table or counting',
      ),
    );
  }

  int? _numberFromLearningCommand(String command) {
    final lower = command.toLowerCase();
    final digitMatch = RegExp(r'\b(?:10|[2-9])\b').firstMatch(lower);
    if (digitMatch != null) {
      return int.parse(digitMatch.group(0)!);
    }

    const words = {
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9,
      'ten': 10,
      'do': 2,
      'teen': 3,
      'chaar': 4,
      'char': 4,
      'paanch': 5,
      'panch': 5,
      'chay': 6,
      'che': 6,
      'saat': 7,
      'aath': 8,
      'nau': 9,
      'das': 10,
    };
    for (final entry in words.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    const urduWords = {
      'دو': 2,
      'تین': 3,
      'چار': 4,
      'پانچ': 5,
      'چھ': 6,
      'سات': 7,
      'آٹھ': 8,
      'آٹھ': 8,
      'نو': 9,
      'دس': 10,
    };
    for (final entry in urduWords.entries) {
      if (command.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  void _appendDigitOrDecimal(String value) {
    if (_isError || _replaceOnNextDigit) {
      _expression = value == '.' ? '0.' : value;
      _display = _expression;
      _isError = false;
      _replaceOnNextDigit = false;
      return;
    }

    final currentNumber = _lastNumber(_expression);
    if (value == '.' && currentNumber.contains('.')) {
      return;
    }

    if (_expression == '0' && value != '.') {
      _expression = value;
    } else {
      _expression += value;
    }

    _display = _expression;
  }

  void _appendOperator(String value) {
    if (_isError) {
      return;
    }

    _replaceOnNextDigit = false;
    final last = _expression.substring(_expression.length - 1);
    if (_isOperator(last)) {
      _expression = '${_expression.substring(0, _expression.length - 1)}$value';
    } else {
      _expression += value;
    }
    _display = _expression;
  }

  void _toggleSign() {
    if (_isError || _expression == '0') {
      return;
    }

    final match = RegExp(r'(-?\d+\.?\d*)$').firstMatch(_expression);
    if (match == null) {
      return;
    }

    final number = match.group(0)!;
    final replacement = number.startsWith('-')
        ? number.substring(1)
        : '-$number';
    _expression = _expression.replaceRange(match.start, match.end, replacement);
    _display = _expression;
  }

  void _applyPercent() {
    if (_isError) {
      return;
    }

    final match = RegExp(r'(-?\d+\.?\d*)$').firstMatch(_expression);
    if (match == null) {
      return;
    }

    final value = double.parse(match.group(0)!) / 100;
    final replacement = _formatNumber(value);
    _expression = _expression.replaceRange(match.start, match.end, replacement);
    _display = _expression;
  }

  void _evaluate() {
    try {
      final calculation = _expression;
      final result = ExpressionEvaluator(_expression).evaluate();
      _memory = result;
      _expression = _formatNumber(result);
      _display = _expression;
      _isError = false;
      _replaceOnNextDigit = true;
      _lastAnswerValue = _display;
      _history.insert(
        0,
        _CalculationRecord(expression: calculation, answer: _display),
      );
      if (_history.length > 5) {
        _history.removeLast();
      }
      unawaited(_speak(_answerSpeech(_display)));
    } on FormatException {
      _display = 'Try again';
      _isError = true;
      _replaceOnNextDigit = true;
      unawaited(_speak(_tryAgainSpeech()));
    }
  }

  String _lastNumber(String expression) {
    final match = RegExp(r'(-?\d+\.?\d*)$').firstMatch(expression);
    return match?.group(0) ?? '';
  }

  bool _isOperator(String value) {
    return const ['+', '-', _multiplySymbol, _divideSymbol].contains(value);
  }

  String _formatNumber(double value) {
    if (!value.isFinite) {
      throw const FormatException('Invalid result');
    }

    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(10)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _LearningDrawer(
        onTablePressed: _speakTable,
        onCountingPressed: _startCountingSpeech,
        onStopPressed: _stopLearningSpeech,
        onMicPressed: _listenForLearningCommand,
        isSpeakingLearning: _isTableSequenceActive || _isCountingSequenceActive,
        isListeningForCommand: _isListeningForCommand,
        voiceCommandStatus: _voiceCommandStatus,
        activeTableNumber: _activeTableNumber,
        activeTableLine: _activeTableLine,
        activeCountingNumber: _activeCountingNumber,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF4B8), Color(0xFFCFF3FF), Color(0xFFFFD3F0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    return _Header(
                      speakUrdu: _speakUrdu,
                      onCapPressed: () => Scaffold.of(context).openDrawer(),
                      onLanguagePressed: _toggleSpeechLanguage,
                      onAboutPressed: _showAboutInfo,
                    );
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 4,
                  child: _DisplayPanel(
                    display: _display,
                    expression: _expression,
                    isError: _isError,
                    hasAnswer: _lastAnswerValue != null,
                    onRepeatAnswer: _repeatLastAnswer,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 3,
                  child: _HistoryPanel(
                    records: _history,
                    onRepeat: (record) => unawaited(
                      _speak(
                        _calculationSpeech(record.expression, record.answer),
                      ),
                    ),
                    onClearHistory: _clearHistory,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 10,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 8.0;
                      final cellWidth =
                          (constraints.maxWidth - spacing * 3) / 4;
                      final cellHeight =
                          (constraints.maxHeight - spacing * 4) / 5;

                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: cellWidth / cellHeight,
                        ),
                        itemCount: _buttons.length,
                        itemBuilder: (context, index) {
                          final button = _buttons[index];
                          return _KidButton(
                            spec: button,
                            onPressed: () => _buttonPressed(button.label),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutInfo() {
    unawaited(_speak(_aboutSpeech()));
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFFFC857), width: 4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCFF3FF),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 18,
                        color: Color(0x22000000),
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(_appIconAsset, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  _appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF243B53),
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                const _InfoChip(
                  icon: Icons.verified_rounded,
                  text: 'Version $_appVersion',
                  color: Color(0xFF06D6A0),
                ),
                const SizedBox(height: 10),
                const _InfoChip(
                  icon: Icons.favorite_rounded,
                  text: _poweredByShort,
                  color: Color(0xFFFF5E78),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LearningDrawer extends StatelessWidget {
  const _LearningDrawer({
    required this.onTablePressed,
    required this.onCountingPressed,
    required this.onStopPressed,
    required this.onMicPressed,
    required this.isSpeakingLearning,
    required this.isListeningForCommand,
    required this.voiceCommandStatus,
    required this.activeTableNumber,
    required this.activeTableLine,
    required this.activeCountingNumber,
  });

  final ValueChanged<int> onTablePressed;
  final VoidCallback onCountingPressed;
  final VoidCallback onStopPressed;
  final VoidCallback onMicPressed;
  final bool isSpeakingLearning;
  final bool isListeningForCommand;
  final String voiceCommandStatus;
  final int? activeTableNumber;
  final int? activeTableLine;
  final int? activeCountingNumber;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width.clamp(280.0, 360.0).toDouble(),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF4B8), Color(0xFFCFF3FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _LearningDrawerHeader(
                isSpeakingLearning: isSpeakingLearning,
                onStopPressed: onStopPressed,
                onMicPressed: onMicPressed,
                isListeningForCommand: isListeningForCommand,
                voiceCommandStatus: voiceCommandStatus,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  children: [
                    _DrawerSection(
                      icon: Icons.grid_on_rounded,
                      title: 'Tables',
                      child: Column(
                        children: [
                          _TimesTable(
                            number: 2,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 2
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 3,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 3
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 4,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 4
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 5,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 5
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 6,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 6
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 7,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 7
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 8,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 8
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 9,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 9
                                ? activeTableLine
                                : null,
                          ),
                          _TimesTable(
                            number: 10,
                            onPressed: onTablePressed,
                            activeLine: activeTableNumber == 10
                                ? activeTableLine
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _DrawerSection(
                      icon: Icons.format_list_numbered_rounded,
                      title: 'Counting 1-100',
                      onHeaderTap: onCountingPressed,
                      child: Column(
                        children: List.generate(
                          100,
                          (index) => _CountingRow(
                            number: index + 1,
                            isActive: activeCountingNumber == index + 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningDrawerHeader extends StatelessWidget {
  const _LearningDrawerHeader({
    required this.isSpeakingLearning,
    required this.onStopPressed,
    required this.onMicPressed,
    required this.isListeningForCommand,
    required this.voiceCommandStatus,
  });

  final bool isSpeakingLearning;
  final VoidCallback onStopPressed;
  final VoidCallback onMicPressed;
  final bool isListeningForCommand;
  final String voiceCommandStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                key: const ValueKey('close-learning-menu'),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                color: const Color(0xFF7C3AED),
                tooltip: 'Back to calculator',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF06D6A0), width: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fixedSize: const Size(48, 48),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF06D6A0), width: 3),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFF7C3AED),
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Learning Menu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF243B53),
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (isSpeakingLearning) ...[
                const SizedBox(width: 8),
                IconButton(
                  key: const ValueKey('stop-learning-speech'),
                  onPressed: onStopPressed,
                  icon: const Icon(Icons.stop_rounded),
                  color: Colors.white,
                  tooltip: 'Stop',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E78),
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    fixedSize: const Size(48, 48),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              IconButton(
                key: const ValueKey('voice-command-button'),
                onPressed: onMicPressed,
                icon: Icon(
                  isListeningForCommand
                      ? Icons.mic_rounded
                      : Icons.mic_none_rounded,
                ),
                color: Colors.white,
                tooltip: 'Voice command',
                style: IconButton.styleFrom(
                  backgroundColor: isListeningForCommand
                      ? const Color(0xFFFF5E78)
                      : const Color(0xFF7C3AED),
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fixedSize: const Size(48, 48),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.86),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              voiceCommandStatus,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF5C677D),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSection extends StatelessWidget {
  const _DrawerSection({
    required this.icon,
    required this.title,
    required this.child,
    this.onHeaderTap,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final VoidCallback? onHeaderTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              key: ValueKey('drawer-section-$title'),
              onTap: onHeaderTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(icon, color: const Color(0xFF7C3AED), size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF243B53),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (onHeaderTap != null)
                      const Icon(
                        Icons.volume_up_rounded,
                        color: Color(0xFF06A77D),
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _TimesTable extends StatelessWidget {
  const _TimesTable({
    required this.number,
    required this.onPressed,
    required this.activeLine,
  });

  final int number;
  final ValueChanged<int> onPressed;
  final int? activeLine;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ExpansionTile(
        key: ValueKey('table-$number'),
        onExpansionChanged: (expanded) {
          if (expanded) {
            onPressed(number);
          }
        },
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        iconColor: const Color(0xFF7C3AED),
        collapsedIconColor: const Color(0xFF7C3AED),
        title: Text(
          '$number Table / ${_urduNumbers[number]} کا پہاڑا',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF243B53),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        children: List.generate(10, (index) {
          final multiplier = index + 1;
          final answer = number * multiplier;
          return _MathFactRow(
            left: '$number × $multiplier = $answer',
            right:
                '${_urduNumbers[number]} ضرب ${_urduNumbers[multiplier]} = ${_urduNumbers[answer]}',
            isActive: activeLine == multiplier,
          );
        }),
      ),
    );
  }
}

class _MathFactRow extends StatelessWidget {
  const _MathFactRow({
    required this.left,
    required this.right,
    required this.isActive,
  });

  final String left;
  final String right;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return _ActiveAutoScroller(
      isActive: isActive,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFC857) : const Color(0xFFFFF4B8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFFFF5E78) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (isActive) ...[
                  const Icon(
                    Icons.volume_up_rounded,
                    color: Color(0xFF7C3AED),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    left,
                    style: const TextStyle(
                      color: Color(0xFF243B53),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Color(0xFF5C677D),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveAutoScroller extends StatefulWidget {
  const _ActiveAutoScroller({required this.isActive, required this.child});

  final bool isActive;
  final Widget child;

  @override
  State<_ActiveAutoScroller> createState() => _ActiveAutoScrollerState();
}

class _ActiveAutoScrollerState extends State<_ActiveAutoScroller> {
  @override
  void initState() {
    super.initState();
    _scrollIfActive();
  }

  @override
  void didUpdateWidget(covariant _ActiveAutoScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _scrollIfActive();
    }
  }

  void _scrollIfActive() {
    if (!widget.isActive) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        alignment: 0.45,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _CountingRow extends StatelessWidget {
  const _CountingRow({required this.number, required this.isActive});

  final int number;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return _ActiveAutoScroller(
      isActive: isActive,
      child: Container(
        key: ValueKey('counting-row-$number'),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFFFC857)
              : number.isEven
              ? const Color(0xFFCFF3FF)
              : const Color(0xFFFFD3F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFFFF5E78) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (isActive) ...[
              const Icon(
                Icons.volume_up_rounded,
                color: Color(0xFF7C3AED),
                size: 18,
              ),
              const SizedBox(width: 6),
            ],
            SizedBox(
              width: 34,
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Color(0xFF243B53),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _englishNumberForLearning(number),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF243B53),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _urduNumbers[number] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF5C677D),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _englishNumberForLearning(int number) {
    const ones = [
      'zero',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen',
    ];
    const tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety',
    ];

    if (number < 20) {
      return ones[number];
    }
    if (number < 100) {
      final rest = number % 10;
      return rest == 0
          ? tens[number ~/ 10]
          : '${tens[number ~/ 10]} ${ones[rest]}';
    }

    return 'one hundred';
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({
    required this.records,
    required this.onRepeat,
    required this.onClearHistory,
  });

  final List<_CalculationRecord> records;
  final ValueChanged<_CalculationRecord> onRepeat;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'History',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF243B53),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('clear-history'),
                onPressed: onClearHistory,
                icon: const Icon(Icons.delete_sweep_rounded),
                color: records.isEmpty
                    ? const Color(0xFF7B8794)
                    : const Color(0xFFFF5E78),
                tooltip: 'Clear history',
                constraints: const BoxConstraints.tightFor(
                  width: 30,
                  height: 26,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 0),
          Expanded(
            child: records.isEmpty
                ? const Center(
                    child: Text(
                      'History will appear here',
                      style: TextStyle(
                        color: Color(0xFF7B8794),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: records.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCFF3FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${record.expression} = ${record.answer}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF243B53),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            IconButton(
                              key: ValueKey('repeat-history-$index'),
                              onPressed: () => onRepeat(record),
                              icon: const Icon(Icons.volume_up_rounded),
                              color: Color(0xFF7C3AED),
                              tooltip: 'Repeat',
                              constraints: const BoxConstraints.tightFor(
                                width: 34,
                                height: 34,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CalculationRecord {
  const _CalculationRecord({required this.expression, required this.answer});

  final String expression;
  final String answer;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.34), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF243B53),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.speakUrdu,
    required this.onCapPressed,
    required this.onLanguagePressed,
    required this.onAboutPressed,
  });

  final bool speakUrdu;
  final VoidCallback onCapPressed;
  final VoidCallback onLanguagePressed;
  final VoidCallback onAboutPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: 'Learning menu',
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 5,
            shadowColor: const Color(0x22000000),
            child: InkWell(
              key: const ValueKey('learning-menu-button'),
              onTap: onCapPressed,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF06D6A0), width: 3),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFF7C3AED),
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rainbow Calculator',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF243B53),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Tap, learn, and count',
                style: TextStyle(
                  color: Color(0xFF5C677D),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: 'About',
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            elevation: 5,
            shadowColor: const Color(0x22000000),
            child: InkWell(
              onTap: onAboutPressed,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFB39CD0), width: 3),
                ),
                child: const Icon(
                  Icons.info_rounded,
                  color: Color(0xFF7C3AED),
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: speakUrdu ? 'Switch to English' : 'اردو آواز',
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            elevation: 5,
            shadowColor: const Color(0x22000000),
            child: InkWell(
              onTap: onLanguagePressed,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 66,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: speakUrdu
                        ? const Color(0xFF06D6A0)
                        : const Color(0xFFFFC857),
                    width: 3,
                  ),
                ),
                child: Text(
                  speakUrdu ? 'UR' : 'EN',
                  style: TextStyle(
                    color: speakUrdu
                        ? const Color(0xFF00866A)
                        : const Color(0xFFB26A00),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DisplayPanel extends StatelessWidget {
  const _DisplayPanel({
    required this.display,
    required this.expression,
    required this.isError,
    required this.hasAnswer,
    required this.onRepeatAnswer,
  });

  final String display;
  final String expression;
  final bool isError;
  final bool hasAnswer;
  final VoidCallback onRepeatAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            color: Color(0x22000000),
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              const _MiniStar(color: Color(0xFFFFC857)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  expression == display ? 'Ready for math' : expression,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7B8794),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                key: const ValueKey('repeat-answer'),
                onPressed: onRepeatAnswer,
                icon: const Icon(Icons.replay_rounded),
                color: hasAnswer
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF7B8794),
                tooltip: 'Repeat answer',
                constraints: const BoxConstraints.tightFor(
                  width: 24,
                  height: 20,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              display,
              maxLines: 1,
              style: TextStyle(
                color: isError
                    ? const Color(0xFFE63946)
                    : const Color(0xFF102A43),
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KidButton extends StatelessWidget {
  const _KidButton({required this.spec, required this.onPressed});

  final _ButtonSpec spec;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: spec.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey('button-${spec.label}'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              color: spec.color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.26),
                  blurRadius: 9,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Center(
                child: _PictureBadge(
                  label: spec.label,
                  background: spec.badgeColor,
                  foreground: spec.color,
                  pictureIndex: spec.pictureIndex,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PictureBadge extends StatelessWidget {
  const _PictureBadge({
    required this.label,
    required this.background,
    required this.foreground,
    required this.pictureIndex,
  });

  final String label;
  final Color background;
  final Color foreground;
  final int pictureIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: CustomPaint(
          painter: _PicturePainter(
            color: foreground,
            pictureIndex: pictureIndex,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: _isLongLabel(label) ? 18 : 34,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isLongLabel(String label) => label.length > 1;
}

class _MiniStar extends StatelessWidget {
  const _MiniStar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _PicturePainter(color: color, pictureIndex: 4),
      ),
    );
  }
}

class _PicturePainter extends CustomPainter {
  const _PicturePainter({required this.color, required this.pictureIndex});

  final Color color;
  final int pictureIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.24)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color.withValues(alpha: 0.38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.06
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.22;
    final mode = pictureIndex % 5;

    if (mode == 0) {
      canvas.drawCircle(center, radius * 1.25, paint);
      canvas.drawCircle(
        center.translate(-radius, -radius),
        radius * 0.45,
        paint,
      );
      canvas.drawCircle(center.translate(radius, radius), radius * 0.45, paint);
    } else if (mode == 1) {
      final rect = Rect.fromCenter(
        center: center,
        width: radius * 2.5,
        height: radius * 2.5,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius * 0.35)),
        paint,
      );
      canvas.drawLine(
        center.translate(-radius * 1.2, 0),
        center.translate(radius * 1.2, 0),
        stroke,
      );
    } else if (mode == 2) {
      final path = Path()
        ..moveTo(center.dx, center.dy - radius * 1.45)
        ..lineTo(center.dx + radius * 1.4, center.dy + radius)
        ..lineTo(center.dx - radius * 1.4, center.dy + radius)
        ..close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, stroke);
    } else if (mode == 3) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2.9,
          height: radius * 1.8,
        ),
        paint,
      );
      canvas.drawLine(
        center.translate(-radius * 1.5, -radius),
        center.translate(radius * 1.5, radius),
        stroke,
      );
    } else {
      final path = Path();
      for (var i = 0; i < 10; i++) {
        final angle = -1.5708 + i * 0.6283;
        final starRadius = i.isEven ? radius * 1.55 : radius * 0.68;
        final point = center.translate(
          starRadius * MathCos.sin(angle + 1.5708),
          starRadius * MathCos.sin(angle),
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _PicturePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.pictureIndex != pictureIndex;
  }
}

class MathCos {
  static double sin(double radians) {
    const p = 0.225;
    final normalized = _normalize(radians);
    final sine = normalized < 0
        ? 1.27323954 * normalized + 0.405284735 * normalized * normalized
        : 1.27323954 * normalized - 0.405284735 * normalized * normalized;
    return sine < 0
        ? p * (sine * -sine - sine) + sine
        : p * (sine * sine - sine) + sine;
  }

  static double _normalize(double radians) {
    const pi = 3.1415926535897932;
    const twoPi = pi * 2;
    var value = radians;
    while (value > pi) {
      value -= twoPi;
    }
    while (value < -pi) {
      value += twoPi;
    }
    return value;
  }
}

class _ButtonSpec {
  const _ButtonSpec(this.label, this.color, this.badgeColor, this.pictureIndex);

  final String label;
  final Color color;
  final Color badgeColor;
  final int pictureIndex;
}

class ExpressionEvaluator {
  ExpressionEvaluator(String source)
    : _source = source
          .replaceAll(_multiplySymbol, '*')
          .replaceAll(_divideSymbol, '/');

  final String _source;
  int _index = 0;

  double evaluate() {
    final value = _parseExpression();
    _skipWhitespace();
    if (_index != _source.length) {
      throw const FormatException('Unexpected input');
    }
    return value;
  }

  double _parseExpression() {
    var value = _parseTerm();

    while (true) {
      _skipWhitespace();
      if (_consume('+')) {
        value += _parseTerm();
      } else if (_consume('-')) {
        value -= _parseTerm();
      } else {
        return value;
      }
    }
  }

  double _parseTerm() {
    var value = _parseNumber();

    while (true) {
      _skipWhitespace();
      if (_consume('*')) {
        value *= _parseNumber();
      } else if (_consume('/')) {
        final divisor = _parseNumber();
        if (divisor == 0) {
          throw const FormatException('Division by zero');
        }
        value /= divisor;
      } else {
        return value;
      }
    }
  }

  double _parseNumber() {
    _skipWhitespace();
    final start = _index;

    if (_peek() == '-') {
      _index++;
    }

    while (_index < _source.length &&
        (RegExp(r'\d').hasMatch(_source[_index]) || _source[_index] == '.')) {
      _index++;
    }

    if (start == _index || _source.substring(start, _index) == '-') {
      throw const FormatException('Expected number');
    }

    return double.parse(_source.substring(start, _index));
  }

  bool _consume(String character) {
    if (_peek() == character) {
      _index++;
      return true;
    }
    return false;
  }

  String? _peek() {
    if (_index >= _source.length) {
      return null;
    }
    return _source[_index];
  }

  void _skipWhitespace() {
    while (_index < _source.length && _source[_index].trim().isEmpty) {
      _index++;
    }
  }
}
