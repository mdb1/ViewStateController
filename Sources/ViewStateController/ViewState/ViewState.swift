//
//  ViewState.swift
//
//
//  Created by Manu on 28/02/2023.
//

import Foundation

/// Enum that represents the state of a view that loads information from the backend.
public enum ViewState<Info> {
    /// Represents non state. Useful when used in combination with other ViewState.
    case initial
    /// Represents the loading state.
    case loading
    /// Represents an error.
    case error(_: Error)
    /// Represents that the information has been loaded correctly.
    case loaded(_ info: Info)

    /// Returns true if state is loading.
    public var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }

    /// Returns info associated to loaded state.
    public var info: Info? {
        guard case let .loaded(info) = self else { return nil }
        return info
    }

    /// Returns info associated to error state.
    public var error: Error? {
        guard case let .error(error) = self else { return nil }
        return error
    }
}

// Future-improvement: Make Info conform to equatable for a realistic `==` implementation.
extension ViewState: Equatable {
    public static func == (lhs: ViewState<Info>, rhs: ViewState<Info>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
