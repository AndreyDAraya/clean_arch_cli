import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

/// {@template create_entity_command}
/// A command that creates a new entity in a feature
/// {@endtemplate}
class CreateEntityCommand extends Command<void> {
  /// {@macro create_entity_command}
  CreateEntityCommand(this._logger) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The name of the entity to create',
        mandatory: true,
      )
      ..addOption(
        'feature',
        abbr: 'f',
        help: 'The feature where to create the entity',
        mandatory: true,
      );
  }

  final Logger _logger;

  @override
  String get description => 'Creates a new entity in a feature';

  @override
  String get name => 'entity';

  @override
  Future<void> run() async {
    final entityName = argResults?['name'] as String;
    final featureName = argResults?['feature'] as String;
    final rc = ReCase(entityName);
    final featureRc = ReCase(featureName);

    _logger.info(
        'Creating entity: ${rc.snakeCase} in feature: ${featureRc.snakeCase}');

    final currentDir = Directory.current;
    final featureDir = Directory(
        path.join(currentDir.path, 'lib', 'features', featureRc.snakeCase));
    if (!featureDir.existsSync()) {
      _logger.err('Feature ${featureRc.pascalCase} does not exist');
      throw StateError('Feature ${featureRc.pascalCase} does not exist');
    }

    final entityFile = File(path.join(
      featureDir.path,
      'domain',
      'entities',
      '${rc.snakeCase}.dart',
    ));

    if (!entityFile.existsSync()) {
      entityFile.createSync(recursive: true);
      entityFile.writeAsStringSync('''
import 'package:equatable/equatable.dart';

class ${rc.pascalCase} extends Equatable {
  const ${rc.pascalCase}();

  @override
  List<Object?> get props => [];
}
''');

      // Create corresponding model
      final modelFile = File(path.join(
        featureDir.path,
        'data',
        'models',
        '${rc.snakeCase}_model.dart',
      ));

      if (!modelFile.existsSync()) {
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
import '../../domain/entities/${rc.snakeCase}.dart';

class ${rc.pascalCase}Model extends ${rc.pascalCase} {
  const ${rc.pascalCase}Model();

  factory ${rc.pascalCase}Model.fromJson(Map<String, dynamic> json) {
    return ${rc.pascalCase}Model();
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  factory ${rc.pascalCase}Model.fromEntity(${rc.pascalCase} entity) {
    return ${rc.pascalCase}Model();
  }
}
''');
      }

      _logger.success(
          'Entity ${rc.pascalCase} and its model created successfully! 🎉');
    } else {
      _logger.err('Entity ${rc.pascalCase} already exists');
      throw StateError('Entity ${rc.pascalCase} already exists');
    }
  }
}
