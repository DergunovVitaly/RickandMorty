//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Vitaliy on 06.02.2025.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var window: UIWindow?

    var body: some Scene {
        WindowGroup {
            EmptyView()
                .onChange(of: scenePhase) { newPhase, _ in
                    switch newPhase {
                    case .active, .inactive, .background:
                        createWindowIfNeeded()
                    @unknown default:
                        break
                    }
                }
        }
    }
    
    private func createWindowIfNeeded() {
        guard window == nil else { return }
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
            return
        }
        let newWindow = UIWindow(windowScene: windowScene)
        let networkService = RickAndMortyNetworkService()
        let characterListViewModel = CharacterListViewModel(networkService: networkService)
        let characterListVC = CharacterListViewController(viewModel: characterListViewModel)
        let navigationController = UINavigationController(rootViewController: characterListVC)
        
        newWindow.rootViewController = navigationController
        newWindow.makeKeyAndVisible()
        window = newWindow
    }
}
