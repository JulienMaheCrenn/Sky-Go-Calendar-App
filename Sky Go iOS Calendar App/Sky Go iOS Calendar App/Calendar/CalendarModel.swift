//
//  CalendarModel.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 03/03/2023.
//

import Foundation
import FirebaseDatabase
import Combine

protocol CalendarModelProtocol {
    func getUsers ( date:String, location:String, department:String, completion: @escaping (Result <[User], FirebaseError>) -> ())
    func handleOfficeDayBooking( date:String, location:String, department:String, completion: @escaping ((Result <String, FirebaseError>) -> () ) )
    func updateUserLocation (completion: @escaping (Result < String, FirebaseError >) -> ())
    func populateLocationDropdown() -> [String]
}

class CalendarModel: CalendarModelProtocol {

    private let database:DatabaseReferenceProtocol
    private let userUID:String
    private var cancellable:AnyCancellable?

    
    init(userUID:String, database: DatabaseReferenceProtocol) {
        self.userUID = userUID
        self.database = database
    }
    
    func getUsers ( date:String, location:String, department:String, completion: @escaping (Result <[User], FirebaseError>) -> ()) {
        getUserUIDs(date: date, location: location, department: department, completion: {result in
            switch result {
            case .success(let userUIDArray):

                let futures = userUIDArray.map { self.makeAFuturePublisher(for: $0) }
                var userArray:[User] = []
                
                self.cancellable = Publishers.MergeMany(futures).sink (receiveCompletion:{ completed in
                    switch completed {
                    case .finished:
                        print(userArray)
                        completion(.success(userArray))
                    case .failure(let failure):
                        print(failure)
                        completion(.failure(failure))
                    }
                }, receiveValue: { value in
                    print(value)
                    userArray.append(value)
                })

            case .failure:
                completion(.success([]))
            }
        })
    }
    
    private func makeAFuturePublisher(for userUID: String) -> Future<User, FirebaseError> {
        print("Make a future publisher called")
        
       return Future<User, FirebaseError> { promise in
           self.database.child("users").child(userUID).observeSingleEvent(of: .value, with: {snapshot in
                guard let value = snapshot.value as? NSObject else {
                promise(.failure(.standard))
                return
            }
               let currentUser = User(name: self.populateUserStruct(value: value, key: "name"),
                                      jobTitle:self.populateUserStruct(value: value, key: "jobTitle"),
                                      department: self.populateUserStruct(value: value, key:"department"),
                                      location: self.populateUserStruct(value: value, key: "location")
                )
                
                promise(.success(currentUser))
            }
                                                                      
           )}
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

    func handleOfficeDayBooking( date:String, location:String, department:String, completion: @escaping ((Result <String, FirebaseError>) -> () ) ) {

        let appointmentUser: [String:Any] = ["\(self.userUID)": true]
        let userAppointment: [String:Any] = ["\(date)": "\(location)"]
        
        self.database.child("appointments").child(date).child(location).child(department).updateChildValues(appointmentUser)
        self.database.child("users").child(self.userUID).child("appointments").updateChildValues(userAppointment)
        
        checkBooking(date: date, location: location, department: department, completion: {result in
            switch result {
            case .success:
                completion(.success("Booking Successful"))
            case .failure:
                completion(.success("There was an error booking your office day, please try again"))
            }
        })
    }
    
    private func checkBooking(date:String, location:String, department:String, completion: @escaping (Result <Bool, FirebaseError>) -> () ) {
        database.child("appointments").child(date).child(location).child(department).child(self.userUID).observeSingleEvent(of: .value, with: {snapshot in
            guard let appointment = snapshot.value as? Bool else {
                completion(.failure(.standard))
                return
            }
            completion(.success(appointment))
        })
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
