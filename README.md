# ViewStateController

[![Swift](https://github.com/mdb1/ViewStateController/actions/workflows/swift.yml/badge.svg)](https://github.com/mdb1/ViewStateController/actions/workflows/swift.yml)

ViewStateController is a framework for Swift and SwiftUI developers that provides a simple and flexible way to manage the state of views that load information from a backend. It allows you to handle different states based on a historical array of states, and provides properties and methods to help you access and modify the state. With ViewStateController, you can easily implement complex views that depend on asynchronous data loading, and create a better user experience by showing loading spinners or error messages.

There is an Example app available [here](https://github.com/mdb1/ViewStateControllerExampleApp), where most of the configuration options can be tweaked.

# Table of contents

* [ViewStateController Object](https://github.com/mdb1/ViewStateController#viewstatecontroller-object)
  * [ViewStateModifier](https://github.com/mdb1/ViewStateController#viewstatemodifier)
    * [withViewStateModifier](https://github.com/mdb1/ViewStateController#withviewstatemodifier-method)
  * [LoadingModifierType](https://github.com/mdb1/ViewStateController#loadingmodifiertype)
  * [Usage](https://github.com/mdb1/ViewStateController#usage)
  * [Examples with code samples](https://github.com/mdb1/ViewStateController#examples-with-code-samples)
    * [Redacted](https://github.com/mdb1/ViewStateController#redacted)
    * [Changing the indicator view](https://github.com/mdb1/ViewStateController#changing-the-indicator-view)
    * [Changing Loading types](https://github.com/mdb1/ViewStateController#changing-loading-types)
    * [Using Custom Views](https://github.com/mdb1/ViewStateController#using-custom-views)
  * [Demo](https://github.com/mdb1/ViewStateController#demo-loading-type-options)
  * [ModifyingIds](https://github.com/mdb1/ViewStateController#modifying-ids)
      * [Demo](https://github.com/mdb1/ViewStateController#demo-modifying-ids)
  * [DebugState](https://github.com/mdb1/ViewStateController#debug-state)
* [Toasts](https://github.com/mdb1/ViewStateController#toast)
  * [Examples with code samples](https://github.com/mdb1/ViewStateController#examples-with-code-samples-1)

# ViewStateController Object

The [ViewStateController](https://github.com/mdb1/ViewStateController/blob/main/Sources/ViewStateController/ViewState/ViewStateController.swift) struct is the one that contains the array of historical [ViewStates](https://mdb1.github.io/2023-01-08-new-app-view-state/) and has computed properties that will be used by the ViewStateModifier to determine what to do.

* `isInitialLoading`: Returns true only if loading state was set once and there hasn't been errors or info yet.
* `isLoading`: Returns true if state is loading.
* `latestValidInfo`: Info associated to the last time `loaded` state was set. Nil if there has been an error after the latest info.
* `latestInfo`: Info associated to the last time `loaded` state was set, disregarding if there has been an error afterwards.
* `latestValidError`: Info associated to the last time `error` state was set. Nil if `info` has been loaded after the latest error.
* `latestError`: Info associated to the last time loaded `error` was set, disregarding if there has been an error afterwards.
* `latestNonLoading`:  Returns the latest informational state (info, or error) if exists. Nil otherwise.

There are also two mutating methods: 

* `setState(_ state: ViewState<Info>)`: Sets the new state into the states array.
* `reset()`: Resets everything.

## ViewStateModifier

The [ViewStateModifier](https://github.com/mdb1/ViewStateController/blob/main/Sources/ViewStateController/ViewModifiers/ViewStateModifier.swift) is a ViewModifier that uses the given ViewStateController and configurable options to automatically update the state of a view.

The code of the modifier is pretty straight forward:
```swift
func body(content: Content) -> some View {
    if controller.isInitialLoading {
        // Initial loading modifier displayed on the initial loading state.
        content.modifier(initialLoadingModifier)
    } else if let info = controller.latestValidInfo {
        // If we have valid info loaded we display it:
        loadedView(info)
            .if(controller.isLoading) { view in
                // If we are on a subsequent loading, we add the modifier.
                view.modifier(loadingAfterInfoModifier)
            }
    } else if let error = controller.latestValidError {
        // If we have a value error we display it:
        errorView(error)
            .if(controller.isLoading) { view in
                // If we are on a subsequent loading, we add the modifier.
                view.modifier(loadingAfterErrorModifier)
            }
    } else {
        // Otherwise, we display the initial content.
        content
    }
}
```

### withViewStateModifier method

The `withViewStateModifier` method, is just a convenience way to add the ViewStateModifier to any view:

```swift
/// Adds a view state modifier that can display different views depending on the state of a `ViewStateController`.
/// - Parameters:
///   - controller: The `ViewStateController` that controls the state of the view.
///   - indicatorView: The view to show when the view is loading.
///   - initialLoadingType: The type of loading indicator to show when the view is initially loading.
///   - loadedView: The view to show when the view is not loading and has valid information.
///   - loadingAfterInfoType: The type of loading indicator to show when the view is loading after it has already
///     displayed valid information.
///   - errorView: The view to show when the view has an error.
///   - loadingAfterErrorType: The type of loading indicator to show when the view is loading after it has displayed
///     an error.
func withViewStateModifier<Info, IndicatorView: View, LoadedView: View>(
    controller: ViewStateController<Info>,
    indicatorView: IndicatorView = ProgressView(),
    initialLoadingType: LoadingModifierType = .material(),
    loadedView: @escaping (Info) -> LoadedView,
    loadingAfterInfoType: LoadingModifierType = .horizontal(),
    errorView: @escaping (Error) -> ErrorView,
    loadingAfterErrorType: LoadingModifierType = .overCurrentContent(alignment: .trailing)
) -> some View
```

## LoadingModifierType

The [LoadingModifierType](https://github.com/mdb1/ViewStateController/blob/main/Sources/ViewStateController/ViewModifiers/LoadingViewModifier.swift) provides some different loading options with configurable parameters.

## Usage

The ideal usage would be to:

1. Decide your strategy for `initialLoading`, `loadingAfterInfo`, `errorView`, and `loadingAfterError` states.
2. Create the placeholder view (The one that will be there before the initial loading). (This could be an `EmptyView()` or the `loadedView` with a `.redacted` modifier).
3. Create the `loadedView`.
4. Decide if the error state will have a retry action or not.

## Examples with code samples

Let's take a look at how we can use it in our views:

We will be using this view and controller in our examples:
```swift
@State var controller: ViewStateController<User> = .init()

...

struct User {
    let name: String
    let age: Int
    let emoji: String
}

...

func loadedView(user: User) -> some View {
    HStack(spacing: 8) {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.gray.opacity(0.2))
            Text(user.emoji)
        }
        VStack(alignment: .leading, spacing: 8) {
            Text("Name: \(user.name)")
            Text("Age: \(user.age.description)")
        }
        Spacer()
    }
}
```

### Redacted

```swift
loadedView(user: .init(name: "Placeholder", age: 99, emoji: "")) // 1. Create a placeholder view
    .redacted(reason: .placeholder) // 2. Use redacted to hide the texts
    .withViewStateModifier( // 3. Apply view modifier
        controller: controller
    ) { user in 
        loadedView(user: user) // 4. Provide the view for the loaded information
    } errorView: { _ in // 5. Provide an error view
        .init { setLoading() }
    }
```

https://user-images.githubusercontent.com/5333984/222929861-695a50d0-d503-4f03-a69e-da70c7027e5c.mov

Since we are not changing the values for the loading types it's using the default values:

* `.material()` for the initial loading
* `.horizontal()` for the loading after info type
* `.overCurrentContent(alignment: .trailing)` for the loading after error type

### Changing the indicator view

If you have a custom progress view, you can use it in the `indicatorView` parameter. Example from [this post](https://mdb1.github.io/2023-01-04-new-app-components/):

```swift
loadedView(user: .init(name: "Placeholder", age: 99, emoji: ""))
    .redacted(reason: .placeholder)
    .withViewStateModifier(
        controller: controller,
        indicatorView: SpinnerProgressView(color: .green)
    ) { user in
        loadedView(user: user)
    } errorView: { _ in
        .init { setLoading() }
    }
```

https://user-images.githubusercontent.com/5333984/222929864-76133f77-25b3-49ac-81b6-38cdb443324e.mov

### Changing Loading types

By changing the `initialLoadingType`, `loadingAfterInfoType`, or `loadingAfterErrorType` you can provide different ways of displaying the loading states. 

You can find a list of the possible options [here](https://github.com/mdb1/ViewStateController/blob/main/Sources/ViewStateController/ViewModifiers/LoadingViewModifier.swift)

Example:
```swift
loadedView(user: .init(name: "Placeholder", age: 99, emoji: ""))
    .redacted(reason: .placeholder)
    .withViewStateModifier(
        controller: controller,
        indicatorView: SpinnerProgressView(color: .purple), // Mark 1
        initialLoadingType: .vertical(option: .bottom, alignment: .center), // Mark 2
        loadedView: { user in
            loadedView(user: user)
        },
        loadingAfterInfoType: .horizontal(option: .leading, contentOpacity: 0.3, alignment: .center, spacing: 32), // Mark 3
        errorView: { _ in .init { setLoading() } },
        loadingAfterErrorType: .overCurrentContent(contentOpacity: 0.5, alignment: .bottomTrailing) // Mark 4
        )
```

In this example:

* Mark 1: We are changing the indicator view to use a custom one.
* Mark 2: We are changing the initial loading type, to use a VStack with the indicator at the bottom and center alignment.
* Mark 3: We are changing the loading after info type, to use an HStack with the indicator in the leading position, 0.3 as the opacity for the content, center alignment, and 32 of spacing.
* Mark 4: We are changing the loading after error type to use the `overCurrentContent` type with 0.5 for the content opacity, and bottomTrailing alignment. 

https://user-images.githubusercontent.com/5333984/222929867-8e1afc93-dc0b-47c3-8014-3a9cda76b02d.mov

### Using Custom Views

Let's say that the screen/view you are working on requires some special views for each state. You could use the `.custom` type for any of the states:

```swift
EmptyView() // Mark 1
    .withViewStateModifier(
        controller: controller,
        indicatorView: SpinnerProgressView(color: .orange), // Mark 2
        initialLoadingType: .custom( // Mark 3
            VStack {
                Text("This is the initial loading")
                SpinnerProgressView(color: .blue, size: 50, lineWidth: 5)
            }.asAnyView()
        ),
        loadedView: { user in
            loadedView(user: user)
        },
        loadingAfterInfoType: .custom( // Mark 4
            HStack {
                Image(systemName: "network")
                Text("I got info, but I am loading again")
                SpinnerProgressView(color: .black)
            }.asAnyView()
        ),
        errorView: { error in // Mark 5
            .init(type: .custom(
                VStack {
                    Text("I got an error")
                    Text(error.localizedDescription)
                }
                .foregroundColor(.red)
                .asAnyView()
            ))
        },
        loadingAfterErrorType: .custom( // Mark 6
            HStack {
                Image(systemName: "network")
                Text("I got info, but I am loading again")
                SpinnerProgressView(color: .red)
            }
            .foregroundColor(.red)
            .asAnyView()
        ))
```

In this example:

* Mark 1: We are using an EmptyView as the placeholder view.
* Mark 2: We are changing the indicator view to use a custom one.
* Mark 3: We are changing the initial loading type, to use a custom view.
* Mark 4: We are changing the loading after info type, to use a custom view.
* Mark 5: We are changing the error view, to use a custom view.
* Mark 6: We are changing the loading after error type, to use a custom view.

https://user-images.githubusercontent.com/5333984/222929869-8eec3ce7-ce59-491c-a46d-824243b348e9.mov

## Demo: Loading Type Options

https://user-images.githubusercontent.com/5333984/222930157-f1c0ef5d-4383-4073-87c2-9d98e2f09c29.mp4

In this video, we are tweaking around some properties and pass them to the `withViewStateModifier` to demonstrate the different loading and error states that comes for free. Everything is configurable, and there is also the ability to provide custom views for loading states, the indicator, and the error states.

The app used for this video can be downloaded from [this repository](https://github.com/mdb1/ViewStateControllerExampleApp). 

## Modifying Ids

The ViewStateController object also provided an array of Strings (modifyingIds):

```swift
/// Use this property when you need to make changes to specific parts of your view.
/// Example: When you want to display a ProgressView while deleting an item from a list.
public var modifyingIds: [String]?
```

It's usage is really simple:

```swift
func listView(_ pokemons: [Pokemon]) -> some View {
    VStack {
        ForEach(pokemons) { pokemon in
            HStack {
                Text(pokemon.name)
                Spacer()
                trailingView(for: pokemon.id)
            }
            Divider()
        }
    }
}

@ViewBuilder
func trailingView(for id: String) -> some View {

    if let modifyingIds = controller.modifyingIds, modifyingIds.contains(id) {
        // If the id is in the `modifyingIds` array, it means someone is modifying it.
        // So we display a loading indicator.
        ProgressView()
    } else {
        // Otherwise, we display a remove button.
        Button("Remove", role: .destructive) {
            Task {
                // Tapping the button triggers an async call to remove the pokemon.
                await removePokemon(id: id)
            }
        }
    }
}

func removePokemon(id: String) async {
    withAnimation {
        // We add the `id` to the array.
        controller.modifyingIds = (controller.modifyingIds ?? []) + [id]
    }
    // We simulate an async call to the backend. (1 second sleep)
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    if let latestInfo = controller.latestInfo {
        let updatedInfo = latestInfo.filter { pokemon in
            pokemon.id != id
        }
        withAnimation {
            // Then we update the state
            controller.setState(.loaded(updatedInfo))
            // And remove the id from the modifying array
            controller.modifyingIds?.removeAll(where: { $0 == id })
        }
    }
}

struct Pokemon: Identifiable {
    let id: String
    let name: String
}
```

### Demo: Modifying Ids

https://user-images.githubusercontent.com/5333984/225748007-ff1e0fed-8e80-4b73-9f3e-d83b7edc3064.mov

## Debug State
For DEBUG builds, there is a view extension that you can apply to any view, that lets you modify the state of the controller with ease.

```swift
/// Applies the debug state modifier to the view.
/// By tapping 3 times on the view, a modal will be displayed with options to debug
/// the state of the controller.
extension View {
    public func debugState<Info>(
        controller: Binding<ViewStateController<Info>>,
        mockInfo: Info
    ) -> some View {
        #if DEBUG
        // Only apply the debug state modifier in debug builds
        self.modifier(DebugStateModifier(controller: controller, mockInfo: mockInfo))
        #endif
    }
}
```

Usage:
```swift
someView
    .debugState(controller: $controller, mockInfo: someMockInfo)
```

https://user-images.githubusercontent.com/5333984/231207650-8579219c-e583-4180-aeaf-c114eaf22586.mov

# Toasts

Similar to the LoadingModifier, there is also a [ToastModifier](https://github.com/mdb1/ViewStateController/blob/main/Sources/ViewStateController/ViewModifiers/ToastModifier.swift) that let's you present toast/snack bars/custom views in the screen with a set of configurable parameters.

https://user-images.githubusercontent.com/5333984/223858961-f9d14879-1f12-4b59-af0f-9120867a071d.mp4

## Examples with code samples

### SnackBar
Let's say we want a snack bar to be displayed at the bottom of the screen, we can achieve that with these lines of code:

```swift
@State private var displayToast: Bool = false

...

YourView
    .toast(
        isShowing: $displayToast,
        type: .snackBar(options: .init(message: .init(text: "Hey There"))),
        transitionOptions: .init(transition: .move(edge: .bottom).combined(with: .opacity)),
        positionOptions: .init(position: .bottom)
    )
```

## Note about re-using the same toast/snack bar

When you want to use the same modifier, and present the toast/snack bar multiple times, you need to remember to first hide the one that you were showing (in case it's on the screen), and then display the new one:

```swift
Button("Toast") {
    if displayToast {
        // If the toast was being displayed, trigger the hide action.
        displayToast = false
    }
    // And then trigger the show action.
    withAnimation {
        displayToast = true
    }
}
```

This will ensure that the `second` toast, gets rendered on the screen for the full amount of seconds (in the transitionOptions.duration property) before being dismissed.

To properly check that your code is working, you can uncomment the `print("😄 Timer tick. Elapsed seconds: \(elapsedSeconds)")` line, and check the Xcode console.

https://user-images.githubusercontent.com/5333984/223858908-7ba01ac8-2630-4d4b-b220-2977e2757a3b.mp4

# Internal Project Tools

## Formatter

To run the formatter, just run the following command from the root of the repository:

`swiftformat . --config "Sources/.swiftformat" --swiftversion 5.7`

You need to have `SwiftFormat` installed (`brew install swiftformat`).
