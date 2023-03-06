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

    
    
    func updateUserLocation (completion: @escaping (Result < String, FirebaseError >) -> ()) {
        self.database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
            guard let user = snapshot.value as? NSMutableDictionary, let userLocation = user.value(forKey: "location") as? String else{
                completion(.failure(.standard))
                return
            }
            completion(.success(userLocation))
        })
    }
}
