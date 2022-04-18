import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:dcat/dcat.dart';

void main(List<String> args) {
  exitCode = 0;

  final parser = ArgParser()
    ..addFlag('showLine', negatable: false, abbr: 's')
    ..addFlag('showHighlight', negatable: false, abbr: 'l');

  ArgResults argResults = parser.parse(args);
  final paths = argResults.rest;

  dcat(
    paths,
    showLineNumbers: argResults['showLine'] as bool?,
    showHighlight: argResults['showHighlight'] as bool?,
  );
}

Future<void> dcat(
  List<String> paths, {
  bool? showLineNumbers = false,
  bool? showHighlight = false,
}) async {
  if (paths.isEmpty) {
    await stdin.pipe(stdout);
  } else {
    for (final path in paths) {
      var lineNumber = 1;

      var lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());

      try {
        stdout.writeln('Cat Program version 1.0');
        stdout.writeln('------------------------');

        await for (var line in lines) {
          if (showLineNumbers!) {
            stdout.write("${lineNumber++}");
          }
          if (showHighlight!) {
            var highlighter = ConsoleHighlighter(
              line,
              keywords: [
                'abstract',
                'as',
                'assert',
                'async',
                'await',
                'break',
                'case',
                'catch',
                'class',
                'const',
                'late',
                'required',
                'continue',
                'default',
                'deferred',
                'do',
                'dynamic',
                'else',
                'enum',
                'export',
                'external',
                'extends',
                'factory',
                'false',
                'final',
                'finally',
                'for',
                'get',
                'if',
                'implements',
                'import',
                'in',
                'is',
                'library',
                'new',
                'null',
                'operator',
                'part',
                'rethrow',
                'return',
                'set',
                'static',
                'super',
                'switch',
                'sync',
                'this',
                'throw',
                'true',
                'try',
                'typedef',
                'var',
                'void',
                'while',
                'with',
                'yield',
                'show'
              ],
            );

            highlighter.format();

            stdout.writeln(' ' + highlighter.buffer);
          } else {
            stdout.writeln(" " + line);
          }
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

//help
Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('Error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
