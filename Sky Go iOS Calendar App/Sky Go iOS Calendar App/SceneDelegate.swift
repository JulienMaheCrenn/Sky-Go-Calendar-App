//
//  SceneDelegate.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 07/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let database:DatabaseReference = Database.database(url:"https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let userUID = Auth.auth().currentUser?.uid {
                let database = self.database
                let tabBarViewController = TabBarController(userUID: userUID, database: database)
                self.window?.rootViewController = tabBarViewController
            } else {
                let signInNavigationController = UINavigationController(rootViewController: UserSignInViewController(database: self.database))
                self.window?.rootViewController = signInNavigationController
            }
        }
        
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
    }

}

