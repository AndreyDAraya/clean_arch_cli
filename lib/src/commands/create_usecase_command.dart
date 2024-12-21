import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

/// {@template create_usecase_command}
/// A command that creates a new use case in a feature
/// {@endtemplate}
class CreateUseCaseCommand extends Command<void> {
  /// {@macro create_usecase_command}
  CreateUseCaseCommand(this._logger) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The name of the use case to create',
        mandatory: true,
      )
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'The feature where to create the use case',
        mandatory: true,
      );
  }

  final Logger _logger;

  @override
  String get description => 'Creates a new use case in a feature';

  @override
  String get name => 'usecase';

  @override
  Future<void> run() async {
    final useCaseName = argResults?['name'] as String;
    final featureName = argResults?['feature'] as String;
    final rc = ReCase(useCaseName);
    final featureRc = ReCase(featureName);

    _logger.info(
        'Creating use case: ${rc.snakeCase} in feature: ${featureRc.snakeCase}');

    final currentDir = Directory.current;
    final featureDir = Directory(
        path.join(currentDir.path, 'lib', 'features', featureRc.snakeCase));
    if (!featureDir.existsSync()) {
      _logger.err('Feature ${featureRc.pascalCase} does not exist');
      throw StateError('Feature ${featureRc.pascalCase} does not exist');
    }

    final useCaseFile = File(path.join(
      featureDir.path,
      'domain',
      'usecases',
      '${rc.snakeCase}.dart',
    ));

    if (!useCaseFile.existsSync()) {
      useCaseFile.createSync(recursive: true);
      useCaseFile.writeAsStringSync('''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/${featureRc.snakeCase}_repository.dart';

class ${rc.pascalCase} {
  final ${featureRc.pascalCase}Repository repository;

  ${rc.pascalCase}(this.repository);

  Future<Either<Failure, void>> call() async {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
''');

      _logger.success('Use case ${rc.pascalCase} created successfully! 🎉');
    } else {
      _logger.err('Use case ${rc.pascalCase} already exists');
      throw StateError('Use case ${rc.pascalCase} already exists');
    }
  }
}
