//
//  LogInPresenter.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 08/03/2023.
//

import Foundation

struct LogInPresenter {
    let logInModel:LogInModel
    
    init(){
        logInModel = LogInModel()
    }
    
    func handleLogin (email:String, password:String) {
        logInModel.handleLogIn(email: email, password: password)
    }
}
