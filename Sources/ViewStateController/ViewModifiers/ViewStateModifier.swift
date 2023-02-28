//
//  ViewStateModifier.swift
//  ViewStateController
//
//  Created by Manu on 22/02/2023.
//

import Foundation
import SwiftUI

public extension View {
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
    ) -> some View {
        modifier(
            ViewStateModifier<Info, IndicatorView, LoadedView>(
                controller: controller,
                initialLoadingModifier: .init(
                    type: initialLoadingType,
                    indicatorView: indicatorView
                ),
                loadedView: loadedView,
                loadingAfterInfoModifier: .init(
                    type: loadingAfterInfoType,
                    indicatorView: indicatorView
                ),
                errorView: errorView,
                loadingAfterErrorModifier: .init(
                    type: loadingAfterErrorType,
                    indicatorView: indicatorView
                )
            )
        )
    }
}

struct ViewStateModifier<Info, IndicatorView: View, LoadedView: View>: ViewModifier {
    private var controller: ViewStateController<Info>
    private var initialLoadingModifier: LoadingViewModifier<IndicatorView>
    private var loadedView: (Info) -> LoadedView
    private var loadingAfterInfoModifier: LoadingViewModifier<IndicatorView>
    private var errorView: (Error) -> ErrorView
    private var loadingAfterErrorModifier: LoadingViewModifier<IndicatorView>

    init(
        controller: ViewStateController<Info>,
        initialLoadingModifier: LoadingViewModifier<IndicatorView>,
        loadedView: @escaping (Info) -> LoadedView,
        loadingAfterInfoModifier: LoadingViewModifier<IndicatorView>,
        errorView: @escaping (Error) -> ErrorView,
        loadingAfterErrorModifier: LoadingViewModifier<IndicatorView>
    ) {
        self.controller = controller
        self.initialLoadingModifier = initialLoadingModifier
        self.loadedView = loadedView
        self.loadingAfterInfoModifier = loadingAfterInfoModifier
        self.errorView = errorView
        self.loadingAfterErrorModifier = loadingAfterErrorModifier
    }

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
}
