//
//  SceneDelegate.swift
//  NewsfeedMVVM
//
//  Created by Ibrahim Mo Gedami on 30.07.2020.
//  Copyright © 2020 Ibrahim Mo Gedami. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        coordinator = AppCoordinator(window: window!)
        coordinator?.start()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStack.shared.saveContext()
    }
}
