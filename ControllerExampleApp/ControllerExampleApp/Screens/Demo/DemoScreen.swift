//
//  DemoScreen.swift
//  ViewStateController
//
//  Created by Manu on 23/02/2023.
//

import ViewStateController
import SwiftUI

struct DemoScreen: View {
    @State var controller: ViewStateController<User> = .init()
    @State private var initialLoadingType: LoadingModifierType = .overCurrentContent()
    @State private var loadingAfterInfoType: LoadingModifierType = .overCurrentContent()
    @State private var loadingAfterErrorType: LoadingModifierType = .overCurrentContent()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                ScrollView {
                    VStack(spacing: 16) {
                        placeholderView
                            .withViewStateModifier(
                                controller: controller,
                                indicatorView: CustomProgressView(),
                                initialLoadingType: initialLoadingType,
                                loadedView: { user in
                                    loadedView(user: user)
                                },
                                loadingAfterInfoType: loadingAfterInfoType,
                                errorView: { _ in
                                    .init(retryAction: { setLoading() })
                                },
                                loadingAfterErrorType: loadingAfterErrorType
                            )
                        
                        Divider()
                        DemoLoadingOptionsView(
                            loadingType: $initialLoadingType,
                            title: "Initial Loading Options"
                        )
                        Divider()
                        DemoLoadingOptionsView(
                            loadingType: $loadingAfterInfoType,
                            title: "Loading After Info Options"
                        )
                        Divider()
                        DemoLoadingOptionsView(
                            loadingType: $loadingAfterErrorType,
                            title: "Loading After Error Options"
                        )
                        Divider()
                    }
                }
                buttons
            }
            .padding()
            .navigationTitle("Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var placeholderView: some View {
        HStack(spacing: 8) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.gray.opacity(0.2))
            VStack(spacing: 8) {
                Text("Placeholder")
                    .materialOverlay()
                Text("Placeholder")
                    .materialOverlay()
            }
            Spacer()
        }
    }

    var buttons: some View {
        HStack {
            Button("Reset") { controller.reset() }
            Button("Loading") { setLoading() }
            Button("Loaded") { setLoaded() }
            Button("Error") { setError() }
        }.buttonStyle(.bordered)
    }

    func loadedView(user: User) -> some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.gray.opacity(0.2))
                Text(user.emoji)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Name: \(user.name)")
                Text("Age: \(user.age.description)")
            }
            Spacer()
        }
    }

    func setLoading() {
        controller.setState(.loading)
    }

    func setError() {
        withAnimation {
            controller.setState(.error(NSError(domain: "An error happened", code: 123)))
        }
    }

    func setLoaded() {
        withAnimation {
            controller.setState(.loaded(
                .init(
                    name: String(UUID().description.dropLast(20)),
                    age: Int.random(in: 10...90),
                    emoji: ["⭐️", "😄", "👻", "🍝"].randomElement() ?? "❌"
                )
            ))
        }

    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoScreen()
    }
}

struct User {
    let name: String
    let age: Int
    let emoji: String
}
