#!/bin/bash

# Exit if any command fails
set -e

# Configuration
PROJECT_NAME="WeathreForecasting"
SCHEME_NAME="WeathreForecasting"
WORKSPACE_NAME="WeathreForecasting.xcworkspace"

# Run SwiftLint
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "SwiftLint not installed, please install it using: brew install swiftlint"
  exit 1
fi

# Run Xcode's static analyzer
xcodebuild analyze -workspace "$WORKSPACE_NAME" -scheme "$SCHEME_NAME" -configuration Release

echo "Static code analysis completed!"
