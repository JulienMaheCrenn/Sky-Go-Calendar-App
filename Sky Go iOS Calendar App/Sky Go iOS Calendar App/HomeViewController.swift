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
    
    let logOutButton = UIButton()
    
    let loginLabel = UILabel()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        setupLabel()
        setupButton()
    }
    
    func setupLabel () {
        view.addSubview(loginLabel)
        
        loginLabel.backgroundColor = .systemOrange
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                self.database.child("users").child(Auth.auth().currentUser!.uid).child("name").observeSingleEvent(of: .value, with: {snapshot in
                    guard let value = snapshot.value as? String else {
                        self.loginLabel.text = "Unable to retrieve user name"
                        return
                    }
                    self.loginLabel.text = "Hello you are logged in as: \(value)"
                })
            } else {
                return
            }


        }
        

        
        loginLabel.textAlignment = .center
        loginLabel.numberOfLines = 0
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.widthAnchor.constraint(equalToConstant: 200),
        ])
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
