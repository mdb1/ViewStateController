//
//  ViewStateControllerResetTests.swift
//  ViewStateControllerTests
//
//  Created by Manu on 22/02/2023.
//

@testable import ViewStateController
import XCTest

final class ViewStateControllerResetTests: XCTestCase {
    func testResetAfterInit() {
        var sut = ViewStateController<Bool>()
        sut.reset()
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [])
        XCTAssertNil(sut.modifyingIds)
    }

    func testReset() {
        var sut = ViewStateController<Bool>()
        sut.setState(.loading)
        sut.setState(.loaded(true))
        sut.setState(.loading)
        sut.setState(.error(SomeError()))
        sut.modifyingIds = ["123", "902"]
        sut.reset()
        let mirror = ViewStateControllerMirror(reflecting: sut)
        XCTAssertEqual(mirror.states, [])
        XCTAssertNil(sut.modifyingIds)
    }
}
