//
//  DemoLoadingOptionsView.swift
//  ViewStateController
//
//  Created by Manu on 26/02/2023.
//

import SwiftUI
import ViewStateController

struct DemoLoadingOptionsView: View {
    private var options: [DemoLoadingOption] = [
        .material,
        .overCurrentContent,
        .none,
        .horizontal,
        .vertical,
        .toolbar
    ]
    @Binding var loadingType: LoadingModifierType
    private let title: String
    @State private var isHidden: Bool = true
    @State private var selectedOption: DemoLoadingOption = .overCurrentContent

    init(
        loadingType: Binding<LoadingModifierType>,
        title: String
    ) {
        self._loadingType = loadingType
        self.title = title
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.title2)
                Spacer()
                Button(isHidden ? "Show" : "Hide") {
                    withAnimation { isHidden.toggle() }
                }
                .buttonStyle(.bordered)
            }

            if !isHidden {
                Group {
                    typePicker
                    materialOptions
                    overCurrentOptions
                    horizontalOptions
                    verticalOptions
                    toolbarOptions
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
                    loadingType = newValue.type
                }
            }
        }
    }

    @ViewBuilder
    var materialOptions: some View {
        if selectedOption.name == .material {
            DemoLoadingMaterialOptionsView(loadingType: $loadingType)
        }
    }

    @ViewBuilder
    var overCurrentOptions: some View {
        if selectedOption.name == .overCurrentContent {
            DemoLoadingOverCurrentOptionsView(loadingType: $loadingType)
        }
    }

    @ViewBuilder
    var horizontalOptions: some View {
        if selectedOption.name == .horizontal {
            DemoLoadingHorizontalOptionsView(loadingType: $loadingType)
        }
    }

    @ViewBuilder
    var verticalOptions: some View {
        if selectedOption.name == .vertical {
            DemoLoadingVerticalOptionsView(loadingType: $loadingType)
        }
    }

    @ViewBuilder
    var toolbarOptions: some View {
        if selectedOption.name == .toolbar {
            DemoLoadingToolbarOptionsView(loadingType: $loadingType)
        }
    }
}

struct DemoLoadingOption: Equatable, Hashable, Identifiable {
    enum Name: String {
        case material
        case overCurrentContent
        case none
        case horizontal
        case vertical
        case toolbar
    }

    let id: String = UUID().description
    let name: Name
    let type: LoadingModifierType

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static let material: Self = .init(name: .material, type: .material())
    static let none: Self = .init(name: .none, type: .none)
    static let overCurrentContent: Self = .init(
        name: .overCurrentContent,
        type: .overCurrentContent()
    )
    static let horizontal: Self = .init(name: .horizontal, type: .horizontal())
    static let vertical: Self = .init(name: .vertical, type: .vertical())
    static let toolbar: Self = .init(name: .toolbar, type: .toolbar())

    static func == (lhs: DemoLoadingOption, rhs: DemoLoadingOption) -> Bool {
        lhs.name == rhs.name
    }
}
