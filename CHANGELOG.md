## 1.0.0

Initial release of clean_arch_cli 🎉

### Features

- Generate complete feature structure with Clean Architecture layers:
  - Data layer (datasources, models, repositories)
  - Domain layer (entities, repositories, use cases)
  - Presentation layer (bloc, pages, widgets)
- Create use cases with proper repository integration and error handling
- Generate entities with corresponding data models and JSON serialization
- Automatic BLoC files generation for state management
- Command-line interface with intuitive commands and options

### Commands

- `feature`: Create a new feature with complete Clean Architecture structure
- `usecase`: Add a new use case to an existing feature
- `entity`: Create a new entity with its corresponding data model

### Dependencies

- args: ^2.4.2 - Command line argument parsing
- mason_logger: ^0.3.1 - Beautiful logging output
- path: ^1.9.0 - Path manipulation utilities
- recase: ^4.1.0 - String case conversion
- yaml: ^3.1.2 - YAML file handling
- cli_completion: ^0.5.1 - CLI command completion
- collection: ^1.18.0 - Collection utilities
- equatable: ^2.0.5 - Value equality
- dartz: ^0.10.1 - Functional programming features
