#!/bin/bash

# Exit if any command fails
set -e

# Configuration
PROJECT_NAME="WeathreForecasting"
SCHEME_NAME="WeathreForecasting"
WORKSPACE_NAME="WeathreForecasting.xcworkspace"
DERIVED_DATA_PATH="./DerivedData"
COVERAGE_REPORT_PATH="./coverage_report"

# Run tests with code coverage
xcodebuild test -workspace "$WORKSPACE_NAME" -scheme "$SCHEME_NAME" -derivedDataPath "$DERIVED_DATA_PATH" -enableCodeCoverage YES

# Generate code coverage report
if which xcov >/dev/null; then
  xcov --workspace "$WORKSPACE_NAME" --scheme "$SCHEME_NAME" --output_directory "$COVERAGE_REPORT_PATH"
else
  echo "xcov not installed, please install it using: gem install xcov"
  exit 1
fi

echo "Tests completed and coverage report generated at $COVERAGE_REPORT_PATH"
