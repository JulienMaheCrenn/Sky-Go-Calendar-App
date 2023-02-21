//
//  SceneDelegate.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 07/02/2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let signInNavigationController = UINavigationController(rootViewController: UserSignInViewController())
//    let homeViewController = UINavigationController(rootViewController: HomeViewController())
    let tabBarViewController = TabBarController()
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                self.window?.rootViewController = self.tabBarViewController
            } else {
                self.window?.rootViewController = self.signInNavigationController
            }
        }
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        

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
    }
    
    func settingTabbar()->(UITabBarController)
    {
        //Setting TabBar
        let tabbar = UITabBarController()

        //Designing Tabbar Item Images
        let calendar = UITabBarItem(title: nil, image:UIImage(named: "calendar.badge.plus") , tag: 0)
        let officeDays = UITabBarItem(title: nil, image: UIImage(named: "list.dash"), tag: 1)

        //Getting TabBar ViewControllers
        let calendarVC = HomeViewController()
        let officeDaysVC = OfficeDaysViewController()
        //Setting ViewControllers on TabBar Items
        calendarVC.tabBarItem = calendar
        officeDaysVC.tabBarItem = officeDays
        let controllers = [calendarVC, officeDaysVC]
        tabbar.viewControllers = controllers
        tabbar.viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
        //Setting Title
        tabbar.navigationItem.title = "Testing Tab Bar"

        return tabbar

    }


}

