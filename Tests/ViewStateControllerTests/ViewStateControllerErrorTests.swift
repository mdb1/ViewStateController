//
//  ViewStateControllerErrorTests.swift
//  ViewStateControllerTests
//
//  Created by Manu on 22/02/2023.
//

@testable import ViewStateController
import XCTest

final class ViewStateControllerErrorTests: XCTestCase {
    func testNilError() {
        let sut = ViewStateController<Bool>()
        XCTAssertNil(sut.latestValidError)
        XCTAssertNil(sut.latestNonLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial])
    }

    func testNotNilError() throws {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        XCTAssertNotNil(sut.latestValidError)
        XCTAssertEqual(sut.latestValidError as? SomeError, SomeError())
        XCTAssertNotNil(sut.latestNonLoading)
        let result = try XCTUnwrap(sut.latestNonLoading)
        switch result {
        case let .failure(err):
            XCTAssertEqual(err as? SomeError, SomeError())
        default:
            XCTFail("Should have been failure.")
        }
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .error(SomeError())])
    }

    func testNotNilErrorWithLoadingAsFinalState() throws {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        sut.setState(.loading)
        XCTAssertNotNil(sut.latestValidError)
        XCTAssertEqual(sut.latestValidError as? SomeError, SomeError())
        let result = try XCTUnwrap(sut.latestNonLoading)
        switch result {
        case let .failure(err):
            XCTAssertEqual(err as? SomeError, SomeError())
        default:
            XCTFail("Should have been failure.")
        }
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .error(SomeError()), .loading])
    }

    func testNilErrorWithLoadedInfoAsFinalState() throws {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        sut.setState(.loading)
        sut.setState(.loaded(true))
        XCTAssertNil(sut.latestValidError)
        XCTAssertNotNil(sut.latestError)
        let result = try XCTUnwrap(sut.latestNonLoading)
        switch result {
        case let .success(value):
            XCTAssertTrue(value)
        default:
            XCTFail("Should have been success.")
        }
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .error(SomeError()), .loading, .loaded(true)])
    }
}
