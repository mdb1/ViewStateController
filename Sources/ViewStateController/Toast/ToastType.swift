//
//  ToastType.swift
//
//
//  Created by Manu on 02/03/2023.
//

import Foundation
import SwiftUI

/// Possible types of toasts.
public enum ToastType {
    /// The default toast, based on some configurable options.
    case toast(options: ToastOptions)
    /// The snack bar toast, based on some configurable options.
    case snackBar(options: SnackBarOptions)
    /// Displays a custom view.
    case custom(_ view: AnyView)
}
