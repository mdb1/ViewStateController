//
//  ViewStateControllerLoadingTests.swift
//  ViewStateControllerTests
//
//  Created by Manu on 22/02/2023.
//

@testable import ViewStateController
import XCTest

final class ViewStateControllerLoadingTests: XCTestCase {
    func testInitialLoadingFalseWhenInitialized() {
        let sut = ViewStateController<Bool>()
        XCTAssertFalse(sut.isInitialLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial])
    }

    func testInitialLoadingTrueForInitialLoading() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        XCTAssertTrue(sut.isInitialLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading])
    }

    func testInitialLoadingFalseWhenThereIsInfo() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.loaded(true))
        XCTAssertFalse(sut.isInitialLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .loaded(true)])
    }

    func testIinitialLoadingFalseWhenThereIsInfoBeforeFirstLoading() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loaded(true))
        sut.setState(.loading)
        XCTAssertFalse(sut.isInitialLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loaded(true), .loading])
    }

    func testInitialLoadingFalseWhenThereIsAnError() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        XCTAssertFalse(sut.isInitialLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .error(SomeError())])
    }

    func testIsLoadingFalseWhenInitialized() {
        let sut = ViewStateController<Bool>()
        XCTAssertFalse(sut.isLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial])
    }

    func testIsLoadingTrueForInitialLoading() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        XCTAssertTrue(sut.isLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading])
    }

    func testIsLoadingFalseWhenThereIsInfo() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.loaded(true))
        XCTAssertFalse(sut.isLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .loaded(true)])
    }

    func testIsLoadingFalseWhenThereIsAnError() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        XCTAssertFalse(sut.isLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .error(SomeError())])
    }

    func testIsLoadingTrueForSubsequentLoadings() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        sut.setState(.loading)
        XCTAssertTrue(sut.isLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .error(SomeError()), .loading])
    }
}
