# Clean Architecture CLI

A command-line tool for generating Clean Architecture structure in Flutter projects.

## Features

- Generate complete feature structure following Clean Architecture principles
- Create use cases with proper dependency injection setup
- Generate entities with corresponding data models
- Automatic BLoC setup for state management

## Installation

```bash
dart pub global activate clean_arch_cli
```

## Usage

### Create a New Feature

```bash
fclean feature --name user_management
```

This will create:

```
lib/
  └── features/
      └── user_management/
          ├── data/
          │   ├── datasources/
          │   ├── models/
          │   └── repositories/
          ├── domain/
          │   ├── entities/
          │   ├── repositories/
          │   └── usecases/
          └── presentation/
              ├── bloc/
              ├── pages/
              └── widgets/
```

### Create a Use Case

```bash
fclean usecase --name get_user_profile --feature user_management
```

This will create:

```dart
// In domain/usecases/get_user_profile.dart
class GetUserProfile {
  final UserManagementRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, void>> call() async {
    // TODO: Implement use case
    throw UnimplementedError();
  }
}
```

### Create an Entity

```bash
fclean entity --name user_profile --feature user_management
```

This creates both the entity and its corresponding model:

```dart
// In domain/entities/user_profile.dart
class UserProfile extends Equatable {
  const UserProfile();

  @override
  List<Object?> get props => [];
}

// In data/models/user_profile_model.dart
class UserProfileModel extends UserProfile {
  const UserProfileModel();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
```

## Structure Generated

The tool generates a complete Clean Architecture structure:

### Data Layer

- Data Sources (Remote/Local)
- Models (Data objects)
- Repository Implementations

### Domain Layer

- Entities (Business objects)
- Repository Interfaces
- Use Cases

### Presentation Layer

- BLoC (Business Logic Component)
- Pages
- Widgets

## Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the GNU GPL v3 License - see the [LICENSE](LICENSE) file for details.

## Author

Andrey Delgado Araya

- Email: andreydelgadoaraya@gmail.com
- GitHub: [@AndreyDAraya](https://github.com/AndreyDAraya)
