//
//  SceneDelegate.swift
//  NotesApp
//
//  Created by Сергей Золотухин on 29.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let router = AppRouter(window: window, navigationController: UINavigationController())
        let moduleBuilder: ModuleBuilderProtocol = ModuleBuilder(router: router)
        let mainViewController = moduleBuilder.buildMainViewController()
        
        router.setRoot(mainViewController, isNavigationBarHidden: true)
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
