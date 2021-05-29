//
//  SceneDelegate.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 16/03/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    lazy var navigationController: UINavigationController = {
        let controller = UINavigationController()
        controller.view.backgroundColor = .white
        controller.setNavigationBarHidden(true, animated: false)
        return controller
    }()
    lazy var appDIContainer = AppDIContainer(navigationController: self.navigationController)
    lazy var appFlowCoordinator: AppFlowCoordinator = {
        let localAppConfigStorage = self.appDIContainer.localAppConfigStorage
        let fetchCurrentProfileUseCase = self.appDIContainer.makeFetchCurrentProfileUseCase()
        return DefaultAppFlowCoordinator(navigationController: self.navigationController,
                                         presentationFactory: self.appDIContainer,
                                         localAppConfigStorage: localAppConfigStorage,
                                         fetchCurrentProfileUseCase: fetchCurrentProfileUseCase)
    }()
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = self.navigationController
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        self.appFlowCoordinator.start(with: .default)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

