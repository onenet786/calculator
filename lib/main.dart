import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

const String _divideSymbol = '\u00F7';
const String _multiplySymbol = '\u00D7';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rainbow Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC857),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
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
  bool _speakUrdu = false;
  final FlutterTts _speaker = FlutterTts();

  @override
  void initState() {
    super.initState();
    unawaited(_setupSpeaker());
  }

  @override
  void dispose() {
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
    await _speaker.setLanguage(_speakUrdu ? 'ur-PK' : 'en-US');
    await _speaker.setSpeechRate(0.42);
    await _speaker.setPitch(1.25);
    await _speaker.setVolume(1);
    await _speaker.awaitSpeakCompletion(false);
  }

  void _toggleSpeechLanguage() {
    setState(() {
      _speakUrdu = !_speakUrdu;
    });
    unawaited(_setupSpeaker());
    unawaited(_speak(_speakUrdu ? 'اردو' : 'English'));
  }

  Future<void> _speakButton(String value) async {
    await _speak(_spokenLabel(value));
  }

  Future<void> _speak(String text) async {
    try {
      await _speaker.stop();
      await _speaker.speak(text);
    } catch (_) {
      // TTS engines are not available in all test environments.
    }
  }

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
      final result = ExpressionEvaluator(_expression).evaluate();
      _memory = result;
      _expression = _formatNumber(result);
      _display = _expression;
      _isError = false;
      _replaceOnNextDigit = true;
      unawaited(_speak(_speakUrdu ? 'برابر ہے $_display' : 'equals $_display'));
    } on FormatException {
      _display = 'Try again';
      _isError = true;
      _replaceOnNextDigit = true;
      unawaited(_speak(_speakUrdu ? 'دوبارہ کوشش کریں' : 'try again'));
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
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF4B8),
              Color(0xFFCFF3FF),
              Color(0xFFFFD3F0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                _Header(
                  speakUrdu: _speakUrdu,
                  onLanguagePressed: _toggleSpeechLanguage,
                ),
                const SizedBox(height: 12),
                Expanded(
                  flex: 2,
                  child: _DisplayPanel(
                    display: _display,
                    expression: _expression,
                    isError: _isError,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  flex: 5,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 10.0;
                      final cellWidth =
                          (constraints.maxWidth - spacing * 3) / 4;
                      final cellHeight =
                          (constraints.maxHeight - spacing * 4) / 5;

                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
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
}

class _Header extends StatelessWidget {
  const _Header({
    required this.speakUrdu,
    required this.onLanguagePressed,
  });

  final bool speakUrdu;
  final VoidCallback onLanguagePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16,
                color: Color(0x26000000),
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.school_rounded,
            color: Color(0xFF7C3AED),
            size: 32,
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
  });

  final String display;
  final String expression;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 4),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              display,
              maxLines: 1,
              style: TextStyle(
                color: isError ? const Color(0xFFE63946) : const Color(0xFF102A43),
                fontSize: 44,
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
  const _KidButton({
    required this.spec,
    required this.onPressed,
  });

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
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _PictureBadge(
                      label: spec.label,
                      background: spec.badgeColor,
                      foreground: spec.color,
                      pictureIndex: spec.pictureIndex,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spec.label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
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
                fontSize: _isLongLabel(label) ? 15 : 24,
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
  const _PicturePainter({
    required this.color,
    required this.pictureIndex,
  });

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
      canvas.drawCircle(center.translate(-radius, -radius), radius * 0.45, paint);
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
  const _ButtonSpec(
    this.label,
    this.color,
    this.badgeColor,
    this.pictureIndex,
  );

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
