# rdm_weather_app

A robust, production-ready Flutter weather application built with clean architecture, Riverpod state management, and comprehensive testing. This project demonstrates best practices for scalable Flutter development, including modular code organization, API integration, and maintainable UI.

---

## Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Setup & Installation](#setup--installation)
- [Environment Variables](#environment-variables)
- [Code Generation](#code-generation)
- [Testing](#testing)
- [Architecture Overview](#architecture-overview)
- [How to Contribute](#how-to-contribute)
- [License](#license)

---

## Features
- Search and display current weather for any city
- 5-day forecast with min/max temperature and weather icons
- Modular UI with custom stateless widgets
- Riverpod for state management and dependency injection
- Error handling for network, API, and parsing issues
- Environment-based API key management
- Unit, widget, and integration tests for all layers
- Code generation for models and assets

---

## Project Structure

```
lib/
  core/
    config/           # API config, constants, and environment
    error/            # Custom exceptions and failure classes
    usecases/         # Domain use cases
    utils/            # Utility classes and helpers
  features/
    weather/
      data/
        datasources/  # Remote data source for weather/forecast
        models/       # Weather and forecast models (freezed, json_serializable)
        repositories/ # Repository implementation
      domain/
        entities/     # Domain entities (Weather, Forecast)
        usecases/     # Use case classes
      presentation/
        pages/        # Main weather page
        widgets/      # Custom UI widgets (search, status, display, forecast)
        providers/    # Riverpod providers and notifiers
  gen/                # Generated assets (flutter_gen)
assets/
  images/             # App images
.env                  # API key and environment variables

# Tests

test/
  features/
    weather/
      data/           # Data layer tests (models, datasources, repositories)
      presentation/   # Widget and page tests
      fakes/          # Fake providers/notifiers for testing
```

---

## Setup & Installation

1. **Clone the repository**
   ```sh
   git clone <your-repo-url>
   cd rdm_weather_app
   ```

2. **Install dependencies**
   ```sh
   flutter pub get
   ```

3. **Set up your API key**
   - Copy `.env.example` to `.env`
   - Add your weather API key:
     ```
     WEATHER_API_KEY=your_api_key_here
     ```

4. **Run the app**
   ```sh
   flutter run
   ```

---

## Environment Variables

- API keys and sensitive config are managed via `.env` (using `flutter_dotenv`).
- Example:
  ```
  WEATHER_API_KEY=your_api_key_here
  ```
- Make sure `.env` is listed in your `pubspec.yaml` under assets.

---

## Code Generation

- **Freezed & JsonSerializable**: For immutable models and serialization.
- **flutter_gen**: For asset management.
- Run code generators:
  ```sh
  flutter pub run build_runner build --delete-conflicting-outputs
  flutter pub run flutter_gen_runner build
  ```

---

## Testing

- Run all tests:
  ```sh
  flutter test
  ```
- Widget and unit tests are in `test/features/weather/`.
- Fakes and provider overrides are used for isolated testing.
- Coverage includes:
  - Data layer (models, datasources, repositories)
  - Presentation layer (widgets, pages)
  - State management (providers, notifiers)

---

## Architecture Overview

- **Clean Architecture**: Separation of concerns between data, domain, and presentation layers.
- **Riverpod**: Modern state management and dependency injection.
- **Testing**: All layers are covered with unit and widget tests, using fakes and mocks where appropriate.
- **Error Handling**: Custom exceptions and failures for robust error management.
- **Code Generation**: Models and assets are generated for maintainability and type safety.

---

## How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a pull request

Please follow the existing code style and add tests for new features.

---

## License

This project is licensed under the MIT License.
