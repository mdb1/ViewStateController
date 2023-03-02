# ViewStateController

// TODO: Add badge

ViewStateController is a framework for Swift and SwiftUI developers that provides a simple and flexible way to manage the state of views that load information from a backend. It allows you to handle different states based on a historical array of states, and provides properties and methods to help you access and modify the state. With ViewStateController, you can easily implement complex views that depend on asynchronous data loading, and create a better user experience by showing loading spinners or error messages.

There is an Example app available [here](// TODO: Insert Link to the Example App repo), where most of the configuration options can be tweaked.

// TODO: Insert Video of the Example App

# ViewStateController Object

# WithViewState Modifier

## Examples with code samples

# Toast




# Internal Project Tools

## ExampleApp

There is an Example App where most of the configurable options can be tweaked to test the different states/looks/behaviors of loading/error/toasts.

The project is in `Sources/ControllerExampleApp/ControllerExampleApp.xcodeproj`

## Formatter

To run the formatter, just run the following command from the root of the repository:

`swiftformat . --config "Sources/.swiftformat" --swiftversion 5.7`

You need to have `SwiftFormat` installed (`brew install swiftformat`).
