# My Coffees

This is a simple application, with the following features.

- User gets a random coffee image (from https://coffee.alexflipnote.dev/)
- User can saves a coffee image as favorite, and then access anytime, even without internet connection.

#### Tech approach:
- Inspired by [Block Wheather Tutorial](https://bloclibrary.dev/#/flutterweathertutorial)
- [hydrated_bloc](https://pub.dev/packages/hydrated_bloc) to persist and restore state
- [cached_network_image](https://pub.dev/packages/cached_network_image) to cache network images
- CoffeeImageAPI built as an isolated package

---

## To Run

Using Flutter CLI:
```sh
# Get dependencies
$ flutter pub get

# Build runner
$ flutter pub run build_runner build --delete-conflicting-outputs

# Flutter run development flavor
$ flutter run --flavor development --target lib/main_development.dart
```

Using Makefile:
```sh
# Get dependencies
$ make prebuild

# Build runner
$ make build_runner

# Flutter run development flavor
$ make run
```
---

## Running Tests

Using Flutter CLI
```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

Using Makefile:
```sh
# Without coverage output
$ make tests

# With coverage output
$ make coverage_tests
```
