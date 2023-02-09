//
//  HomeViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 09/02/2023.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    let logOutButton = UIButton()
    
    let loginLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginLabel)
        view.backgroundColor = .systemPink
        loginLabel.text = "Hello you are logged in"
        setupButton()
    }
    

    func setupButton() {
        view.addSubview(logOutButton)
        

        logOutButton.configuration = .filled()
        logOutButton.configuration?.baseBackgroundColor = .systemRed
        logOutButton.configuration?.title = "Log Out"
        logOutButton.configuration?.baseForegroundColor = .black
        
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 200),
            logOutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
    }
    
    @objc func handleLogOut() {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }

}
