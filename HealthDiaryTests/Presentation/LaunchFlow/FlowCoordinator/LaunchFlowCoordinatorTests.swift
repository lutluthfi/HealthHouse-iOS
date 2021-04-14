//
//  LaunchFlowCoordinatorTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 30/03/21.
//

import XCTest
@testable import DEV_Health_Diary

class LaunchFlowCoordinatorTests: XCTestCase {

    private lazy var sut = LaunchFlowCoordinatorSUT()
    
    override func setUp() {
        super.setUp()
        let windowScene = self.sut.windowScene
        self.sut.sceneDelegate.window = UIWindow(windowScene: windowScene)
        self.sut.sceneDelegate.window?.rootViewController = self.sut.navigationController
        self.sut.sceneDelegate.window?.makeKeyAndVisible()
    }
    
    func test_start_whenInstructorPresentWelcomeUI_thenNavigationControllerPresentWelcomeUI() {
        let requestValue = LNWelcomeViewModelRequestValue()
        
        let instructor = LaunchFlowCoordinatorInstructor.presentWelcomeUI(requestValue, .standard)
        self.sut.coordinator.start(with: instructor)
        
        XCTAssertTrue(self.sut.navigationController.presentedViewController is LNWelcomeController)
    }
    
    func test_start_whenInstructorPushToWelcomeUI_thenNavigationControllerPushToWelcomeUI() {
        let requestValue = LNWelcomeViewModelRequestValue()
        
        let instructor = LaunchFlowCoordinatorInstructor.pushToWelcomeUI(requestValue)
        self.sut.coordinator.start(with: instructor)
        
        XCTAssertTrue(self.sut.navigationController.topViewController is LNWelcomeController)
    }

}

// MARK: LaunchFlowCoordinatorSUT
public struct LaunchFlowCoordinatorSUT {
    
    public let coordinator: LaunchFlowCoordinator
    public let sceneDelegate: SceneDelegate
    public let scene: UIScene
    public let navigationController: UINavigationController
    public let windowScene: UIWindowScene
    
    private let appDIContainer: AppDIContainer
    
    public init() {
        self.scene = UIApplication.shared.connectedScenes.first!
        self.windowScene = self.scene as! UIWindowScene
        self.sceneDelegate = self.windowScene.delegate as! SceneDelegate
        self.navigationController = UINavigationController()
        self.appDIContainer = AppDIContainer(navigationController: self.navigationController)
        self.coordinator = self.appDIContainer.makeLaunchFlowCoordinator()
    }
    
}
