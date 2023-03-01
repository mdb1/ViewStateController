//
//  CustomProgressView.swift
//  ViewStateController
//
//  Created by Manu on 23/02/2023.
//

import SwiftUI

/// The default progress view to share across the app.
struct CustomProgressView: View {
    private let color: Color

    init(color: Color = .accentColor) {
        self.color = color
    }

    var body: some View {
        ProgressView()
            .tint(color)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}

