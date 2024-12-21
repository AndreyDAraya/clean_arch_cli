import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:clean_arch_cli/src/commands/commands.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:test/test.dart';

void main() {
  late Directory testDir;
  late Logger logger;
  late CommandRunner runner;

  setUp(() {
    testDir = Directory('test_project');
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
    testDir.createSync();
    Directory('${testDir.path}/lib').createSync();

    logger = Logger();
    runner = CommandRunner('clean_arch_cli', 'Clean Architecture CLI')
      ..addCommand(CreateFeatureCommand(logger))
      ..addCommand(CreateUseCaseCommand(logger))
      ..addCommand(CreateEntityCommand(logger));
  });

  tearDown(() {
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });

  group('Clean Architecture CLI', () {
    test('creates feature with correct structure', () async {
      final featureName = 'test_feature';

      await IOOverrides.runZoned(
        () async {
          await runner.run(['feature', '--name', featureName]);
        },
        getCurrentDirectory: () => testDir,
      );

      final featureDir = Directory('${testDir.path}/lib/features/$featureName');
      expect(featureDir.existsSync(), true);

      // Verify data layer
      expect(
          Directory('${featureDir.path}/data/datasources').existsSync(), true);
      expect(Directory('${featureDir.path}/data/models').existsSync(), true);
      expect(
          Directory('${featureDir.path}/data/repositories').existsSync(), true);
      expect(
          File('${featureDir.path}/data/repositories/${featureName}_repository_impl.dart')
              .existsSync(),
          true);

      // Verify domain layer
      expect(
          Directory('${featureDir.path}/domain/entities').existsSync(), true);
      expect(Directory('${featureDir.path}/domain/repositories').existsSync(),
          true);
      expect(
          Directory('${featureDir.path}/domain/usecases').existsSync(), true);
      expect(
          File('${featureDir.path}/domain/repositories/${featureName}_repository.dart')
              .existsSync(),
          true);

      // Verify presentation layer
      expect(
          Directory('${featureDir.path}/presentation/bloc').existsSync(), true);
      expect(Directory('${featureDir.path}/presentation/pages').existsSync(),
          true);
      expect(Directory('${featureDir.path}/presentation/widgets').existsSync(),
          true);
      expect(
          Directory('${featureDir.path}/presentation/bloc/$featureName')
              .existsSync(),
          true);

      // Verify bloc files
      expect(
          File('${featureDir.path}/presentation/bloc/$featureName/${featureName}_bloc.dart')
              .existsSync(),
          true);
      expect(
          File('${featureDir.path}/presentation/bloc/$featureName/${featureName}_event.dart')
              .existsSync(),
          true);
      expect(
          File('${featureDir.path}/presentation/bloc/$featureName/${featureName}_state.dart')
              .existsSync(),
          true);
    });

    test('creates use case in existing feature', () async {
      final featureName = 'test_feature';
      final useCaseName = 'get_data';

      await IOOverrides.runZoned(
        () async {
          // Create feature first
          await runner.run(['feature', '--name', featureName]);
          // Create use case
          await runner.run(
              ['usecase', '--name', useCaseName, '--feature', featureName]);
        },
        getCurrentDirectory: () => testDir,
      );

      final useCaseFile = File(
          '${testDir.path}/lib/features/$featureName/domain/usecases/get_data.dart');
      expect(useCaseFile.existsSync(), true);

      final content = useCaseFile.readAsStringSync();
      expect(content.contains('class GetData'), true);
      expect(content.contains('TestFeatureRepository'), true);
    });

    test('creates entity with model in existing feature', () async {
      final featureName = 'test_feature';
      final entityName = 'user';

      await IOOverrides.runZoned(
        () async {
          // Create feature first
          await runner.run(['feature', '--name', featureName]);
          // Create entity
          await runner
              .run(['entity', '--name', entityName, '--feature', featureName]);
        },
        getCurrentDirectory: () => testDir,
      );

      final entityFile = File(
          '${testDir.path}/lib/features/$featureName/domain/entities/user.dart');
      final modelFile = File(
          '${testDir.path}/lib/features/$featureName/data/models/user_model.dart');

      expect(entityFile.existsSync(), true);
      expect(modelFile.existsSync(), true);

      final entityContent = entityFile.readAsStringSync();
      final modelContent = modelFile.readAsStringSync();

      expect(entityContent.contains('class User extends Equatable'), true);
      expect(modelContent.contains('class UserModel extends User'), true);
      expect(modelContent.contains('factory UserModel.fromJson'), true);
      expect(modelContent.contains('Map<String, dynamic> toJson()'), true);
    });

    test('fails when creating use case in non-existent feature', () async {
      await IOOverrides.runZoned(
        () async {
          expect(
            () => runner.run(
                ['usecase', '--name', 'get_data', '--feature', 'non_existent']),
            throwsA(isA<StateError>().having(
              (e) => e.toString(),
              'message',
              contains('Feature NonExistent does not exist'),
            )),
          );
        },
        getCurrentDirectory: () => testDir,
      );
    });

    test('fails when creating entity in non-existent feature', () async {
      await IOOverrides.runZoned(
        () async {
          expect(
            () => runner
                .run(['entity', '--name', 'user', '--feature', 'non_existent']),
            throwsA(isA<StateError>().having(
              (e) => e.toString(),
              'message',
              contains('Feature NonExistent does not exist'),
            )),
          );
        },
        getCurrentDirectory: () => testDir,
      );
    });
  });
}
