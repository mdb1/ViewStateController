//
//  Mirroring.swift
//  ViewStateControllerTests
//
//  Created by Manu on 22/02/2023.
//

import Foundation
import XCTest

/// This class is used as the base for accessing private properties of objects.
///
/// Usage:
/// - Create a new child class for the object you want to test
/// - Add the properties using the same name as in the original implementation.
class MirrorObject {
    private let mirror: Mirror

    init(reflecting: Any) {
        mirror = Mirror(reflecting: reflecting)
    }

    func extract<Class>(variableName: StaticString = #function) -> Class {
        extract(variableName: variableName, mirror: mirror)
    }

    private func extract<Class>(variableName: StaticString, mirror: Mirror) -> Class {
        guard let descendant = mirror.descendant("\(variableName)") as? Class else {
            guard let superclassMirror = mirror.superclassMirror else {
                fatalError("Expected Mirror for superclass")
            }
            return extract(variableName: variableName, mirror: superclassMirror)
        }
        guard let result: Class = try? XCTUnwrap(descendant) else {
            fatalError("Expected unwrapped result")
        }
        return result
    }
}
