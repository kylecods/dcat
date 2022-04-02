import 'dart:convert';

import 'dart:io';

import 'package:args/args.dart';

void main(List<String> args) {
  exitCode = 0;

  final parser = ArgParser()..addFlag('showLine', negatable: false, abbr: 's');

  ArgResults argResults = parser.parse(args);
  final paths = argResults.rest;

  dcat(paths, showLineNumbers: argResults['showLine'] as bool?);
}

Future<void> dcat(List<String> paths, {bool? showLineNumbers = false}) async {
  if (paths.isEmpty) {
    await stdin.pipe(stdout);
  } else {
    for (final path in paths) {
      var lineNumber = 1;

      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());

      try {
        stdout.writeln('Cat Program version 1.0');
        stdout.writeln('------------------------');
        await for (final line in lines) {
          if (showLineNumbers!) {
            stdout.write("${lineNumber++}");
          }
          stdout.writeln(' $line');
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('Error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
