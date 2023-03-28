run:
	fvm flutter run --flavor development --target lib/main_development.dart

build:
	very_good packages get -r

tests:
	fvm flutter test --coverage --test-randomize-ordering-seed random

coverage_tests:
	fvm flutter test --coverage --test-randomize-ordering-seed random
	fvm remove_from_coverage -f coverage/lcov.info -r '\.g\.dart$'
	genhtml coverage/lcov.info -o coverage/
	open coverage/index.html

build_runner:
	fvm flutter packages pub run build_runner build