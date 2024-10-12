#!/bin/bash

# Exit if any command fails
set -e

# Configuration
PROJECT_NAME="WeathreForecasting"
SCHEME_NAME="WeathreForecasting"
WORKSPACE_NAME="WeathreForecasting.xcworkspace"
CONFIGURATION="Release"

# Clean the build folder
xcodebuild clean -workspace "$WORKSPACE_NAME" -scheme "$SCHEME_NAME" -configuration "$CONFIGURATION"

# Build the project
xcodebuild build -workspace "$WORKSPACE_NAME" -scheme "$SCHEME_NAME" -configuration "$CONFIGURATION"

echo "Build completed successfully!"
