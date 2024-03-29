//
//  SignUpPresenter.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 06/03/2023.
//

import Foundation
import FirebaseDatabase

protocol SignUpPresenterDelegate: AnyObject {
}

class SignUpPresenter {

    
    private let signUpModel:SignUpModel
    
    init (database:DatabaseReferenceProtocol) {
        signUpModel = SignUpModel(database: database)
    }
    
    func signUpUser (email:String, password:String, user:User) {
        signUpModel.signUpUser(email: email, password: password, user: user)
    }
    
    func populateDepartmentDropdown() -> [String] {
        signUpModel.populateDepartmentDropdown()
    }
    
    func populateLocationDropdown() -> [String] {
        signUpModel.populateLocationDropdown()
    }

    
}
