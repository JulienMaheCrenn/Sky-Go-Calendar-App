//
//  LogInModel.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 08/03/2023.
//

import Foundation
import FirebaseAuth

class LogInModel {
    func handleLogIn (email:String, password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let _ = self else { return }
        }
    }
}
