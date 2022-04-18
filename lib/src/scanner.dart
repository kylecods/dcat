class Scanner {
  final String source;

  int _position = 0;

  int? _lastMatchedPosition;

  int get position => _position;

  bool get isAtEnd => position == source.length;

  Match? get lastMatched {
    if (_position != _lastMatchedPosition) _lastMatch = null;

    return _lastMatch;
  }

  Scanner(this.source);
  Match? _lastMatch;
  bool match(Pattern pattern) {
    _lastMatch = pattern.matchAsPrefix(source, position);

    _lastMatchedPosition = _position;

    return _lastMatch != null;
  }

  bool advance(Pattern pattern) {
    bool success = match(pattern);

    if (success) {
      _position = _lastMatch!.end;

      _lastMatchedPosition = _position;
    }
    return success;
  }
}
