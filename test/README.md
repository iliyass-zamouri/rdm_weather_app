# Test Structure Documentation

This document describes the test organization for the RDM Weather App, following clean architecture and SOLID principles.

## 🏗️ Architecture Overview

The test structure mirrors the application's clean architecture:

```
test/
├── features/
│   ├── app/              # App feature tests
│   │   └── presentation/ # Presentation layer tests
│   │       ├── pages/    # Page tests
│   │       └── sections/ # Section tests
│   ├── weather/          # Weather feature tests
│   │   ├── domain/       # Domain layer tests
│   │   ├── data/         # Data layer tests
│   │   ├── presentation/ # Presentation layer tests
│   │   └── fakes/        # Fake implementations for testing
│   └── forecast/         # Forecast feature tests
│       ├── domain/       # Domain layer tests
│       ├── data/         # Data layer tests
│       ├── presentation/ # Presentation layer tests
│       └── fakes/        # Fake implementations for testing
├── run_all_tests.sh      # Run all tests
└── README.md             # This file
```

## 🧪 Test Organization

### App Feature Tests (`test/features/app/`)

#### Presentation Layer (`presentation/`)
- **Pages**: Test main app page and navigation
- **Sections**: Test search and status sections

### Weather Feature Tests (`test/features/weather/`)

#### Domain Layer (`domain/`)
- **Entities**: Test domain entities and their computed properties
- **Use Cases**: Test business logic and use case implementations
- **Repositories**: Test repository interfaces (contracts)

#### Data Layer (`data/`)
- **Models**: Test data transfer objects (DTOs)
- **Repositories**: Test repository implementations
- **Data Sources**: Test remote data source implementations
- **Providers**: Test dependency injection providers

#### Presentation Layer (`presentation/`)
- **Providers**: Test state management and business logic
- **Widgets**: Test UI components and their behavior
- **State**: Test state classes and their properties
- **Pages**: Test page-level components

#### Fakes (`fakes/`)
- **Fake Notifiers**: Test doubles for providers
- **Mock Implementations**: Simple mocks for testing

### Forecast Feature Tests (`test/features/forecast/`)

#### Domain Layer (`domain/`)
- **Entities**: Test forecast domain entities
- **Use Cases**: Test forecast business logic
- **Repositories**: Test forecast repository contracts

#### Data Layer (`data/`)
- **Models**: Test forecast data models
- **Repositories**: Test forecast repository implementations
- **Data Sources**: Test forecast remote data sources
- **Providers**: Test dependency injection providers

#### Presentation Layer (`presentation/`)
- **Providers**: Test forecast state management
- **Widgets**: Test forecast UI components
- **State**: Test forecast state classes

#### Fakes (`fakes/`)
- **Fake Notifiers**: Test doubles for forecast providers
- **Mock Implementations**: Simple mocks for forecast testing

## 🚀 Running Tests

### Run All Tests
```bash
./test/run_all_tests.sh
```

### Run App Tests Only
```bash
./test/features/app/run_app_tests.sh
```

### Run Weather Tests Only
```bash
./test/features/weather/run_weather_tests.sh
```

### Run Forecast Tests Only
```bash
./test/features/forecast/run_forecast_tests.sh
```

### Run Specific Test Files
```bash
# App page tests
flutter test test/features/app/presentation/pages/app_page_test.dart

# Weather entity tests
flutter test test/features/weather/domain/entities/weather_test.dart

# Forecast provider tests
flutter test test/features/forecast/presentation/providers/forecast_provider_test.dart

# All app tests
flutter test test/features/app/

# All weather tests
flutter test test/features/weather/

# All forecast tests
flutter test test/features/forecast/
```

## 📋 Test Coverage

### App Feature
- ✅ Pages (AppPage)
- ✅ Sections (SearchSection, StatusSection)

### Weather Feature
- ✅ Domain entities (Weather)
- ✅ Domain repositories (WeatherRepository interface)
- ✅ Data models (WeatherModel)
- ✅ Data repositories (WeatherRepositoryImpl)
- ✅ Data sources (WeatherRemoteDataSourceImpl)
- ✅ Data providers (WeatherRepositoryProvider, WeatherRemoteDataSourceProvider)
- ✅ Use cases (GetWeather)
- ✅ Presentation providers (WeatherNotifier)
- ✅ Presentation state (WeatherState)
- ✅ Presentation widgets (WeatherWidget, WeatherDisplaySection)
- ✅ Presentation pages (WeatherPage)

### Forecast Feature
- ✅ Domain entities (Forecast)
- ✅ Domain repositories (ForecastRepository interface)
- ✅ Data models (ForecastModel)
- ✅ Data repositories (ForecastRepositoryImpl)
- ✅ Data sources (ForecastRemoteDataSourceImpl)
- ✅ Data providers (ForecastRepositoryProvider, ForecastRemoteDataSourceProvider)
- ✅ Use cases (GetForecast)
- ✅ Presentation providers (ForecastNotifier)
- ✅ Presentation state (ForecastState)
- ✅ Presentation widgets (ForecastWidget, ForecastDisplaySection)

## 🔧 Testing Principles

### 1. **Separation of Concerns**
- Each feature has its own test directory
- Tests are organized by architectural layer
- No cross-feature dependencies in tests

### 2. **Clean Architecture Compliance**
- Domain tests don't depend on data or presentation
- Data tests don't depend on presentation
- Presentation tests use fakes/mocks for dependencies

### 3. **SOLID Principles**
- **Single Responsibility**: Each test file focuses on one component
- **Open/Closed**: Tests are extensible without modification
- **Liskov Substitution**: Fakes properly implement interfaces
- **Interface Segregation**: Tests use minimal interfaces
- **Dependency Inversion**: Tests depend on abstractions, not concretions

### 4. **Test Isolation**
- Each test is independent
- No shared state between tests
- Proper setup and teardown

### 5. **Meaningful Test Names**
- Tests describe behavior, not implementation
- Clear arrange-act-assert structure
- Descriptive failure messages

## 🎯 Best Practices

### Test Structure
```dart
group('ComponentName', () {
  setUp(() {
    // Arrange: Set up test dependencies
  });

  test('should do something when condition', () async {
    // Arrange: Prepare test data
    // Act: Execute the behavior
    // Assert: Verify the result
  });
});
```

### Mocking Strategy
- Use fakes for simple test doubles
- Create custom mocks for complex scenarios
- Avoid over-mocking
- Focus on behavior, not implementation details

### Error Testing
- Test both success and failure scenarios
- Verify correct error types and messages
- Test edge cases and boundary conditions

### Widget Testing
- Test widget behavior, not implementation details
- Avoid testing network-dependent components
- Use fake data for consistent test results

## 🐛 Troubleshooting

### Common Issues
1. **Import Errors**: Ensure correct import paths
2. **Missing Dependencies**: Check pubspec.yaml for test dependencies
3. **Network Issues**: Use fake data sources for widget tests
4. **State Management**: Verify provider overrides in tests

### Test Debugging
```bash
# Run with verbose output
flutter test --verbose

# Run specific test with debug info
flutter test test/features/weather/domain/entities/weather_test.dart --verbose

# Check test coverage
flutter test --coverage
```

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Clean Architecture Principles](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)
