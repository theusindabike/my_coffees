run:
	flutter run --flavor development --target lib/main_development.dart


build:
	very_good packages get -r

tests:
	flutter test --coverage --test-randomize-ordering-seed random
