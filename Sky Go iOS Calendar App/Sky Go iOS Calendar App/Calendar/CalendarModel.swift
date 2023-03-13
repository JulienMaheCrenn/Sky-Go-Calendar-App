//
//  CalendarModel.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 03/03/2023.
//

import Foundation
import FirebaseDatabase

struct CalendarModel {

    private let database:DatabaseReference
    private let userUID:String

    
    init(userUID:String, database: DatabaseReference) {
        self.userUID = userUID
        self.database = database
    }
    
    func getUsers ( date:String, location:String, department:String, completion: @escaping (Result <[User], FirebaseError>) -> ()) {
        getUserUIDs(date: date, location: location, department: department, completion: {result in
            switch result {
            case .success(let userUIDArray):
                var userArray:[User] = []
                
//                let userUID = userUIDArray[0]
//                database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
//                    guard let value = snapshot.value as? NSObject else {
//                        completion(.failure(.standard))
//                        return
//                    }
//                    let currentUser = User(name: populateUserStruct(value: value, key: "name"),
//                                           jobTitle:populateUserStruct(value: value, key: "jobTitle"),
//                                           department: populateUserStruct(value: value, key:"department"),
//                                           location: populateUserStruct(value: value, key: "location")
//                    )
//
//                    userArray.append(currentUser)
//                    print(userArray)
//                })
                
                for (index, userUID) in userUIDArray.enumerated() {
                    database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
                        guard let value = snapshot.value as? NSObject else {
                            completion(.failure(.standard))
                            return
                        }
                        let currentUser = User(name: populateUserStruct(value: value, key: "name"),
                                               jobTitle:populateUserStruct(value: value, key: "jobTitle"),
                                               department: populateUserStruct(value: value, key:"department"),
                                               location: populateUserStruct(value: value, key: "location")
                        )
                        
                        userArray.append(currentUser)
                        print(userArray)
                        if index == userUIDArray.count-1 {
                            completion(.success(userArray))
                        }
                        
                    })
                }
                
//                for userUID in userUIDArray {
//                    database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
//                                        guard let value = snapshot.value as? NSObject else {
//                                            completion(.failure(.standard))
//                                            return
//                                        }
//                        let currentUser = User(name: populateUserStruct(value: value, key: "name"),
//                                               jobTitle:populateUserStruct(value: value, key: "jobTitle"),
//                                               department: populateUserStruct(value: value, key:"department"),
//                                               location: populateUserStruct(value: value, key: "location")
//                                               )
//
//                        userArray.append(currentUser)
//                        print(userArray)
//                        completion(.success(userArray))
//                    })
//                }
                
            case .failure:
                return
            }
        })
    }
    
    private func getUserUIDs (date:String, location: String, department: String, completion: @escaping (Result <[String], FirebaseError>) -> () ) {
        database.child("appointments").child(date).child(location).child(department).observeSingleEvent(of: .value, with: {snapshot in
            guard let attendingUsers = snapshot.value as? NSMutableDictionary else {
                completion(.failure(.standard))
                return
            }
            guard let attendingUsersArray = attendingUsers.allKeys as? [String] else {
                completion(.failure(.standard))
                return
            }
            print(attendingUsersArray)
            completion(.success(attendingUsersArray))
        })
    }
    
    private func populateUserStruct (value:NSObject, key:String) -> String {
        let defaultText = "Not Found"
        guard let value = value.value(forKey: key) as? String else {return defaultText}
        return value
    }

    
    func updateUserLocation (completion: @escaping (Result < String, FirebaseError >) -> ()) {
        self.database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
            guard let user = snapshot.value as? NSMutableDictionary, let userLocation = user.value(forKey: "location") as? String else{
                completion(.failure(.standard))
                return
            }
            completion(.success(userLocation))
        })
    }
    
    func populateLocationDropdown() -> [String] {
        let locationDropDownArray = ["Osterley", "Leeds", "Brentwood"]
        return locationDropDownArray
    }
}
