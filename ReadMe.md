 # Weather Forecasting App


## Project Structure

The project follows a standard iOS app structure:

- WeatherForecasting/
  - Models/
  - Views/
  - ViewModels/
  - Services/
  - UI/
    - FiveDayForecastView.swift
  - Utilities/

## Tech Stack

- Swift
- SwiftUI for UI
- Combine for reactive programming
- URLSession for networking
- CoreLocation for location services

## Test Cases

The project includes unit tests for:
- WeatherViewModel
- NetworkService
- LocationManager

To run the tests, use the provided test-coverage-script.sh or run them through Xcode.

## Scripts

Three scripts are provided to assist with development and continuous integration:

1. build-script.sh: Builds the project
2. static-analysis-script.sh: Runs SwiftLint and Xcode's static analyzer
3. test-coverage-script.sh: Runs unit tests and generates a coverage report

### Prerequisites

- SwiftLint: Install via Homebrew with 
brew install swiftlint

- xcov: Install via RubyGems with 
gem install xcov


### Usage

1. Make the scripts executable:

 chmod +x build-script.sh static-analysis-script.sh test-coverage-script.sh

 2. Run the scripts from the command line:
	  ./build-script.sh
	./static-analysis-script.sh
	./test-coverage-script.sh

These scripts will help ensure code quality, run tests, and prepare the app for deployment.
