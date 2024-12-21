import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

/// {@template create_feature_command}
/// A command that creates a new feature with Clean Architecture structure
/// {@endtemplate}
class CreateFeatureCommand extends Command<void> {
  /// {@macro create_feature_command}
  CreateFeatureCommand(this._logger) {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'The name of the feature to create',
      mandatory: true,
    );
  }

  final Logger _logger;

  @override
  String get description =>
      'Creates a new feature with Clean Architecture structure';

  @override
  String get name => 'feature';

  @override
  Future<void> run() async {
    final featureName = argResults?['name'] as String;
    final rc = ReCase(featureName);

    _logger.info('Creating feature: ${rc.snakeCase}');

    // Create feature directory structure
    final currentDir = Directory.current;
    final libDir = Directory(path.join(currentDir.path, 'lib'));
    if (!libDir.existsSync()) {
      _logger
          .err('This command must be run from the root of a Flutter project');
      throw StateError(
          'This command must be run from the root of a Flutter project');
    }

    final featureDir =
        Directory(path.join(libDir.path, 'features', rc.snakeCase));
    _createDirectory(featureDir);

    // Create layers
    final layers = ['data', 'domain', 'presentation'];
    for (final layer in layers) {
      _createLayer(featureDir.path, layer, rc);
    }

    _logger.success('Feature ${rc.pascalCase} created successfully! 🎉');
  }

  void _createDirectory(Directory dir) {
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  void _createLayer(String featurePath, String layer, ReCase rc) {
    final layerDir = Directory(path.join(featurePath, layer));
    _createDirectory(layerDir);

    switch (layer) {
      case 'data':
        _createDataLayer(layerDir.path, rc);
        break;
      case 'domain':
        _createDomainLayer(layerDir.path, rc);
        break;
      case 'presentation':
        _createPresentationLayer(layerDir.path, rc);
        break;
    }
  }

  void _createDataLayer(String layerPath, ReCase rc) {
    // Create data layer directories
    final directories = [
      'datasources',
      'models',
      'repositories',
    ];

    for (final dir in directories) {
      _createDirectory(Directory(path.join(layerPath, dir)));
    }

    // Create repository implementation
    final repoImpl = File(path.join(
      layerPath,
      'repositories',
      '${rc.snakeCase}_repository_impl.dart',
    ));
    if (!repoImpl.existsSync()) {
      repoImpl.writeAsStringSync('''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/${rc.snakeCase}_repository.dart';

class ${rc.pascalCase}RepositoryImpl implements ${rc.pascalCase}Repository {
  ${rc.pascalCase}RepositoryImpl();
}
''');
    }
  }

  void _createDomainLayer(String layerPath, ReCase rc) {
    // Create domain layer directories
    final directories = [
      'entities',
      'repositories',
      'usecases',
    ];

    for (final dir in directories) {
      _createDirectory(Directory(path.join(layerPath, dir)));
    }

    // Create repository interface
    final repo = File(path.join(
      layerPath,
      'repositories',
      '${rc.snakeCase}_repository.dart',
    ));
    if (!repo.existsSync()) {
      repo.writeAsStringSync('''
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class ${rc.pascalCase}Repository {
  // TODO: Add repository methods
}
''');
    }
  }

  void _createPresentationLayer(String layerPath, ReCase rc) {
    // Create presentation layer directories
    final directories = [
      'bloc',
      'pages',
      'widgets',
    ];

    for (final dir in directories) {
      _createDirectory(Directory(path.join(layerPath, dir)));
    }

    // Create bloc files
    final blocDir = Directory(path.join(layerPath, 'bloc', rc.snakeCase));
    _createDirectory(blocDir);

    final blocFiles = [
      '${rc.snakeCase}_bloc.dart',
      '${rc.snakeCase}_event.dart',
      '${rc.snakeCase}_state.dart',
    ];

    for (final file in blocFiles) {
      final blocFile = File(path.join(blocDir.path, file));
      if (!blocFile.existsSync()) {
        blocFile.writeAsStringSync('''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

${file.contains('bloc') ? _createBlocContent(rc) : file.contains('event') ? _createEventContent(rc) : _createStateContent(rc)}
''');
      }
    }
  }

  String _createBlocContent(ReCase rc) => '''
class ${rc.pascalCase}Bloc extends Bloc<${rc.pascalCase}Event, ${rc.pascalCase}State> {
  ${rc.pascalCase}Bloc() : super(${rc.pascalCase}Initial()) {
    // TODO: Add event handlers
  }
}
''';

  String _createEventContent(ReCase rc) => '''
abstract class ${rc.pascalCase}Event extends Equatable {
  const ${rc.pascalCase}Event();

  @override
  List<Object> get props => [];
}
''';

  String _createStateContent(ReCase rc) => '''
abstract class ${rc.pascalCase}State extends Equatable {
  const ${rc.pascalCase}State();
  
  @override
  List<Object> get props => [];
}

class ${rc.pascalCase}Initial extends ${rc.pascalCase}State {}
''';
}
