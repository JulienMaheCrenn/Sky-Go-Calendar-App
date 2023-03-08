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
    private let selectedDate:String
    private let department:String = ""
    private let location:String = ""
    
    init(userUID:String, database: DatabaseReference, initialDate:String) {
        self.userUID = userUID
        self.database = database
        selectedDate = initialDate
    }

    func setupUsersListener() {
        
    }
    
    private func getUsers (completion: @escaping ([User]) -> ()) {
        
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
