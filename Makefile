run:
	flutter run --flavor development --target lib/main_development.dart

build:
	very_good packages get -r

tests:
	flutter test --coverage --test-randomize-ordering-seed random

build_runner:
	flutter packages pub run build_runner build