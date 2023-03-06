//
//  UserAPI.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 02/03/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserAPI {
    
    let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    func getUsers(date:String, location:String) {
        
        database.child("appointments").child(date).child(location).observeSingleEvent(of: .value, with: {snapshot in
            guard let attendingUsers = snapshot.value as? NSMutableDictionary else {
                return
            }
            let attendingUsersArray =
            attendingUsers.map{userUID in
                return String(describing: userUID)
            }
            print(attendingUsersArray)
//            let userArray =
//            users.map{name, jobTitle, department in
//                return User(name: String(describing: name), jobTitle: String(describing: jobTitle), department: String(describing: department))
//            }
        })
    }}
