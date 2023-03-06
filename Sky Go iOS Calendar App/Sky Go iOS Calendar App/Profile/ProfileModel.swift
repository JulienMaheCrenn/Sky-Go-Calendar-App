//
//  ProfileModel.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 03/03/2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct ProfileModel {
    private let userUID:String
    
    private let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()

    init(userUID:String) {
        self.userUID = userUID
    }
    
    func setupUserListener (completion: @escaping (Result < User, FirebaseError>) -> ()) {
        self.database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
                            guard let value = snapshot.value as? NSObject else {
                                completion(.failure(.standard))
                                return
                            }            
            let currentUser = User(name: populateUserStruct(value: value, key: "name"),
                                   jobTitle:populateUserStruct(value: value, key: "jobTitle"),
                                   department: populateUserStruct(value: value, key:"department"),
                                   location: populateUserStruct(value: value, key: "location")
                                   )
            
            completion(.success(currentUser))
        })
    }
    
    private func populateUserStruct (value:NSObject, key:String) -> String {
        let defaultText = "Not Found"
        guard let value = value.value(forKey: key) as? String else {return defaultText}
        return value
    }
    
    func logOut (completion: @escaping (FirebaseError) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            completion(.standard)
          print("Error signing out: %@", signOutError)
        }
    }
}
