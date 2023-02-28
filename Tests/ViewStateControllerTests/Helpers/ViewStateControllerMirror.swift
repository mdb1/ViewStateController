//
//  ViewStateControllerMirror.swift
//  ViewStateControllerTests
//
//  Created by Manu on 22/02/2023.
//

import Foundation
@testable import ViewStateController

final class ViewStateControllerMirror<Info>: MirrorObject {
    init(reflecting controller: ViewStateController<Info>) {
        super.init(reflecting: controller)
    }

    var states: [ViewState<Info>]! { extract() }
}
