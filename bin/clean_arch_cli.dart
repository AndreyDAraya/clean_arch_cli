import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:clean_arch_cli/clean_arch_cli.dart';

Future<void> main(List<String> args) async {
  final logger = Logger();

  try {
    final runner = CommandRunner<void>(
      'fclean',
      'A CLI for creating Clean Architecture structure in Flutter projects.',
    )
      ..addCommand(CreateFeatureCommand(logger))
      ..addCommand(CreateUseCaseCommand(logger))
      ..addCommand(CreateEntityCommand(logger));

    await runner.run(args);
  } catch (e) {
    logger.err('$e');
    exit(1);
  }
}
