//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Vitaliy on 07.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let networkService = RickAndMortyNetworkService()
        let characterListViewModel = CharacterListViewModel(networkService: networkService)
        let characterListVC = CharacterListViewController(viewModel: characterListViewModel)
        let navigationController = UINavigationController(rootViewController: characterListVC)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
