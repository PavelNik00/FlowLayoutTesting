//
//  SceneDelegate.swift
//  FlowLayoutTrsting
//
//  Created by Pavel Nikipelov on 16.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let params = GeometricParams(cellCount: 3, leftInset: 10, rightInset: 10, cellSpacing: 10)
        let viewController = SupplementaryCollectionViewController(using: params)
        window.rootViewController = UINavigationController(rootViewController: viewController)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

