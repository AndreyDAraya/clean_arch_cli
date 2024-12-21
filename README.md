# Clean Architecture CLI

A powerful CLI tool for generating Clean Architecture structure in Flutter projects. This tool helps you quickly scaffold features, use cases, and entities following Clean Architecture principles.

## Features

- 🏗️ Generate complete feature structure with data, domain, and presentation layers
- 🔄 Create use cases with proper repository integration
- 📦 Generate entities with corresponding data models
- ✨ Automatic generation of BLoC files for state management
- 🎯 Follow Clean Architecture best practices

## Installation

```bash
dart pub global activate clean_arch_cli
```

## Usage

### Create a New Feature

Creates a new feature with the complete Clean Architecture structure including data, domain, and presentation layers.

```bash
fclean feature --name user_management
```

This will create:

```
lib/
  features/
    user_management/
      data/
        datasources/
        models/
        repositories/
          user_management_repository_impl.dart
      domain/
        entities/
        repositories/
          user_management_repository.dart
        usecases/
      presentation/
        bloc/
          user_management/
            user_management_bloc.dart
            user_management_event.dart
            user_management_state.dart
        pages/
        widgets/
```

### Create a Use Case

Add a new use case to an existing feature:

```bash
fclean usecase --name get_user_profile --feature user_management
```

This creates a new use case class in the feature's domain layer with proper repository integration.

### Create an Entity

Add a new entity with its corresponding data model:

```bash
fclean entity --name user_profile --feature user_management
```

This creates:

- An entity class in the domain layer
- A corresponding model class in the data layer with JSON serialization support

## Command Reference

### Feature Command

```bash
fclean feature --name <feature-name>
```

Options:

- `--name` or `-n`: Name of the feature to create (required)

### Use Case Command

```bash
fclean usecase --name <usecase-name> --feature <feature-name>
```

Options:

- `--name` or `-n`: Name of the use case to create (required)
- `--feature` or `-f`: Name of the feature where to create the use case (required)

### Entity Command

```bash
fclean entity --name <entity-name> --feature <feature-name>
```

Options:

- `--name` or `-n`: Name of the entity to create (required)
- `--feature` or `-f`: Name of the feature where to create the entity (required)

## Generated Code Structure

### Feature Structure

- **Data Layer**: Contains the implementation of repositories and data sources
  - `datasources/`: External data source implementations
  - `models/`: Data models that implement entities
  - `repositories/`: Repository implementations
- **Domain Layer**: Contains the business logic
  - `entities/`: Business objects
  - `repositories/`: Repository interfaces
  - `usecases/`: Use case implementations
- **Presentation Layer**: Contains UI components and state management
  - `bloc/`: BLoC pattern implementation
  - `pages/`: Screen/page widgets
  - `widgets/`: Reusable UI components

### Use Case Structure

Each use case follows the single responsibility principle and includes:

- Repository dependency
- Call method for executing the use case
- Error handling with Either type from dartz

### Entity Structure

Entities are created with:

- Equatable integration for value comparison
- Corresponding data models with JSON serialization
- Factory methods for entity conversion

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT License - see the [LICENSE](LICENSE) file for details
