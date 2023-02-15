//
//  HomeViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 09/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController {
    
    let database = Database.database(url:"https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    let showProfileButton = UIButton()
    let logOutButton = UIButton()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        setupButtons()
    }
    

    func setupButtons() {
        view.addSubview(logOutButton)
        view.addSubview(showProfileButton)
        

        logOutButton.configuration = .filled()
        logOutButton.configuration?.baseBackgroundColor = .systemRed
        logOutButton.configuration?.title = "Log Out"
        logOutButton.configuration?.baseForegroundColor = .black
        
        showProfileButton.configuration = .filled()
        showProfileButton.configuration?.baseBackgroundColor = .systemGreen
        showProfileButton.configuration?.baseForegroundColor = .white
        showProfileButton.configuration?.title = "Show Profile"
        
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        showProfileButton.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        showProfileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logOutButton.widthAnchor.constraint(equalToConstant: 200),
            logOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            showProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showProfileButton.bottomAnchor.constraint(equalTo: logOutButton.topAnchor, constant: -50),
            showProfileButton.widthAnchor.constraint(equalToConstant: 200),
            showProfileButton.heightAnchor.constraint(equalToConstant: 50),
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
    
    @objc func handleShowProfile () {
        let profileView = ProfileViewController()
        present(profileView, animated: true)
    }

}
