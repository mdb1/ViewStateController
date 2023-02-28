//
//  ViewStateControllerInfoTests.swift
//  ViewStateControllerTests
//
//  Created by Manu on 22/02/2023.
//

@testable import ViewStateController
import XCTest

final class ViewStateControllerInfoTests: XCTestCase {
    func testNilInfo() {
        let sut = ViewStateController<Bool>()
        XCTAssertNil(sut.latestValidInfo)
        XCTAssertNil(sut.latestInfo)
        XCTAssertNil(sut.latestNonLoading)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial])
    }

    func testNotNilInfo() throws {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.loaded(true))
        XCTAssertNotNil(sut.latestValidInfo)
        XCTAssertNotNil(sut.latestInfo)
        XCTAssertEqual(sut.latestValidInfo, true)
        XCTAssertNotNil(sut.latestNonLoading)
        let result = try XCTUnwrap(sut.latestNonLoading)
        XCTAssertEqual(try result.get(), true)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .loaded(true)])
    }

    func testNotNilInfoWithLoadingAsFinalState() throws {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.loaded(true))
        sut.setState(.loading)
        XCTAssertNotNil(sut.latestValidInfo)
        XCTAssertEqual(sut.latestValidInfo, true)
        XCTAssertEqual(sut.latestInfo, true)
        XCTAssertNotNil(sut.latestNonLoading)
        let result = try XCTUnwrap(sut.latestNonLoading)
        XCTAssertEqual(try result.get(), true)
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .loaded(true), .loading])
    }

    func testNilInfoWithErrorAsFinalState() throws {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.loaded(true))
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        XCTAssertNil(sut.latestValidInfo)
        XCTAssertNotNil(sut.latestInfo)
        XCTAssertEqual(sut.latestInfo, true)
        let result = try XCTUnwrap(sut.latestNonLoading)
        switch result {
        case let .failure(err):
            XCTAssertEqual(err as? SomeError, SomeError())
        default:
            XCTFail("Should have been failure.")
        }
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [.initial, .loading, .loaded(true), .loading, .error(SomeError())])
    }
}
