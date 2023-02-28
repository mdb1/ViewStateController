//
//  ViewStateController.swift
//  ViewStateController
//
//  Created by Manu on 22/02/2023.
//

import Foundation

/// ViewStateController is a struct that allows to handle different states based on the array of historical states.
public struct ViewStateController<Info> {
    /// Historical states reference. Initially empty.
    private var states: [ViewState<Info>] = []

    /// Initializes a ViewStateController.
    public init() {
        states = [.initial]
    }

    /// Returns true only if loading state was set once and there hasn't been errors or info yet.
    public var isInitialLoading: Bool {
        states.filter(\.isLoading).count == 1
            && states.filter { $0.info != nil }.isEmpty
            && states.filter { $0.error != nil }.isEmpty
    }

    /// Returns true if state is loading.
    public var isLoading: Bool {
        states.last?.isLoading ?? false
    }

    /// Info associated to the last time `loaded` state was set.
    /// Nil if there has been an error after the latest info.
    public var latestValidInfo: Info? {
        states
            .last(where: { $0 != .initial && $0 != .loading })?
            .info
    }

    /// Info associated to the last time `loaded` state was set,
    /// disregarding if there has been an error afterwards.
    public var latestInfo: Info? {
        states.last { $0.info != nil }?.info
    }

    /// Info associated to the last time `error` state was set.
    /// Nil if `info` has been loaded after the latest error.
    public var latestValidError: Error? {
        states
            .last(where: { $0 != .initial && $0 != .loading })?
            .error
    }

    /// Info associated to the last time loaded `error` was set,
    /// disregarding if there has been an error afterwards.
    public var latestError: Error? {
        states.last { $0.error != nil }?.error
    }

    /// Returns the latest informational state (info, or error) if exists. Nil otherwise.
    public var latestNonLoading: Result<Info, Error>? {
        if let latestValidInfo {
            return .success(latestValidInfo)
        } else if let latestValidError {
            return .failure(latestValidError)
        }

        return nil
    }

    /// Use this property when you need to make changes to specific parts of your view.
    /// Example: When you want to display a ProgressView while deleting an item from a list.
    public var modifyingIds: [String]?

    /// Sets the new state into the states array.
    public mutating func setState(_ state: ViewState<Info>) {
        states.append(state)
    }

    /// Resets everything.
    public mutating func reset() {
        states = []
        modifyingIds = nil
    }
}
