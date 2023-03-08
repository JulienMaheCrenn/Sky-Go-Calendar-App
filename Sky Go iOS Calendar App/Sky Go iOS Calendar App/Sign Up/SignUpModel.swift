//
//  SignUpModel.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 06/03/2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class SignUpModel {
    
    
    private let database:DatabaseReference
    
    init (database:DatabaseReference) {
        self.database = database
    }
    
    func signUpUser (email:String, password:String, profile:[String:Any]) {
        Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
            if (authResult != nil) {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                  guard let _ = self else { return }
                    self?.database.child("users").child(Auth.auth().currentUser!.uid).setValue(profile)
                }
            } else {
                print("Error Signing User Up")
            }
        }
    }
    
    func populateDepartmentDropdown() -> [String] {
        let departmentDropDownArray = ["Sky Go", "Now", "Core", "OVP"]
        return departmentDropDownArray
    }
    
    func populateLocationDropdown() -> [String] {
        let locationDropDownArray = ["Osterley", "Leeds", "Brentwood"]
        return locationDropDownArray
    }
}
