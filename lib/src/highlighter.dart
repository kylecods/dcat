import 'package:colorize/colorize.dart';

import 'scanner.dart';

abstract class Highlighter {
  void format();
}

class ConsoleHighlighter implements Highlighter {
  final String text;

  final Scanner _scanner;

  final List<String> _keywords;

  final List<String> _operators;

  final StringBuffer _stringBuffer;

  String get buffer => _stringBuffer.toString();

  ConsoleHighlighter(this.text,
      {List<String>? keywords, Lang? lang = Lang.csharp})
      : _scanner = Scanner(text),
        _keywords = keywords ?? [],
        _operators = ['=', '>', '<', '!='],
        _stringBuffer = StringBuffer();

  @override
  void format() {
    int lastPositon = _scanner.position;

    while (!_scanner.isAtEnd) {
      if (_scanner.advance(RegExp(r'\s'))) {
        _stringBuffer.write(_scanner.lastMatched![0]!);
      }

      //keywords
      if (_scanner.advance(RegExp(r'[a-zA-Z]+'))) {
        String word = _scanner.lastMatched![0]!;
        if (_keywords.contains(word)) {
          _stringBuffer.write(Colorize(
            word,
          ).lightGreen().toString());
        } else if (_firstLetterToUppercase(word)) {
          _stringBuffer.write(Colorize(
            word,
          ).lightCyan().toString());
        } else {
          _stringBuffer.write(word);
        }
      }

      //operators
      if (_scanner.advance(RegExp(r"[\[\]{}().!=<>&\|\?\+\-\*%\^~;:,_]+"))) {
        String operator = _scanner.lastMatched![0]!;
        if (_operators.contains(operator)) {
          _stringBuffer.write(Colorize(
            operator,
          ).lightRed().toString());

          continue;
        } else {
          _stringBuffer.write(operator);
        }
      }

      if (_scanner.advance(RegExp(r'//.*'))) {
        var value = _scanner.lastMatched![0]!;

        _stringBuffer.write(Colorize(
          value,
        ).lightRed().toString());
        continue;
      }

      if (_scanner.advance(RegExp(r'[0-9]+'))) {
        var digit = _scanner.lastMatched![0]!;

        _stringBuffer.write(Colorize(
          digit,
        ).lightYellow().toString());

        continue;
      }

      /// Raw r"String"
      if (_scanner.advance(RegExp(r'".*"'))) {
        String str = _scanner.lastMatched![0]!;

        _stringBuffer.write(Colorize(
          str,
        ).lightMagenta().toString());

        continue;
      }

      /// Raw r'String'
      if (_scanner.advance(RegExp(r"'.*'"))) {
        String str = _scanner.lastMatched![0]!;

        _stringBuffer.write(Colorize(
          str,
        ).magenta().toString());
        continue;
      }
      if (lastPositon == _scanner.position) {
        break;
      }
      lastPositon = _scanner.position;
    }
  }

  bool _firstLetterToUppercase(String word) {
    String first = word.substring(0, 1);

    return first == first.toUpperCase();
  }
}

enum Lang {
  dart,
  c,
  csharp,
  ln,
  js,
  php,
}
