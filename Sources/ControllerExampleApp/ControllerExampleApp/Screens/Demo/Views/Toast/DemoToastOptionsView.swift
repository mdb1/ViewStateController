//
//  DemoToastOptionsView.swift
//  ControllerExampleApp
//
//  Created by Manu on 02/03/2023.
//

import SwiftUI
import ViewStateController

struct DemoToastOptionsView: View {
    private var options: [DemoToastOption] = [
        .toast,
        .snackBar
    ]
    @Binding var toastType: ToastType
    @Binding var positionOptions: ToastPositionOptions
    @Binding var duration: TimeInterval
    @State private var isHidden: Bool = true
    @State private var selectedOption: DemoToastOption = .toast

    init(
        toastType: Binding<ToastType>,
        positionOptions: Binding<ToastPositionOptions>,
        duration: Binding<TimeInterval>
    ) {
        _toastType = toastType
        _positionOptions = positionOptions
        _duration = duration
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Toast Options")
                    .font(.title2)
                Spacer()
                Button(isHidden ? "Show" : "Hide") {
                    withAnimation { isHidden.toggle() }
                }
                .buttonStyle(.bordered)
            }

            if !isHidden {
                Group {
                    durationView
                    typePicker
                    toastOptions
                    snackBarOptions
                }
                .font(.subheadline)
                .transition(
                    .asymmetric(
                        insertion: AnyTransition.push(from: .top),
                        removal: AnyTransition.push(from: .bottom)
                    )
                )
            }
        }
    }

    var durationView: some View {
        HStack {
            HStack {
                Text("Duration (seconds)")
                Spacer()
            }
            Slider(value: $duration, in: 0.0 ... 32.0, step: 1) { _ in }
            Text(duration.description)
        }
    }

    var typePicker: some View {
        HStack {
            Text("Type")
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(900)

            ZStack {
                Capsule()
                    .foregroundColor(.clear)
                    .background(Color.white.materialOverlay())

                Picker("Please choose a type", selection: $selectedOption) {
                    ForEach(options, id: \.self) {
                        Text($0.name.rawValue)
                    }
                }
                .onChange(of: selectedOption) { newValue in
                    toastType = newValue.type
                }
            }
        }
    }

    @ViewBuilder
    var toastOptions: some View {
        if selectedOption.name == .toast {
            DemoDefaultToastOptionsView(
                toastType: $toastType,
                positionOptions: $positionOptions
            )
        }
    }

    @ViewBuilder
    var snackBarOptions: some View {
        if selectedOption.name == .snackBar {
            DemoSnackBarOptionsView(
                toastType: $toastType,
                positionOptions: $positionOptions
            )
        }
    }
}

struct DemoToastOption: Equatable, Hashable, Identifiable {
    enum Name: String {
        case toast
        case snackBar
    }

    let id: String = UUID().description
    let name: Name
    let type: ToastType

    static let firstLineMessage = "I'm the one who knocks"
    static let secondLineMessage = "Say my name"

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static let toast: Self = .init(
        name: .toast,
        type: .toast(
            options: .init(
                message: .init(text: firstLineMessage)
            )
        )
    )
    static let snackBar: Self = .init(
        name: .snackBar,
        type: .snackBar(
            options: .init(
                message: .init(text: firstLineMessage),
                image: .init()
            )
        )
    )

    static func == (lhs: DemoToastOption, rhs: DemoToastOption) -> Bool {
        lhs.name == rhs.name
    }
}
