//
//  OfficeDaysModel.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 02/03/2023.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol OfficeDaysModelProtocol {
    func setupAppointmentsListener (completion: @escaping (([Appointment]) -> () ))
}

struct OfficeDaysModel: OfficeDaysModelProtocol {
    private let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    func setupAppointmentsListener (completion: @escaping (([Appointment]) -> () )) {
        
        Auth.auth().addStateDidChangeListener{auth, user in
            if Auth.auth().currentUser != nil {
                self.getAppointments(completion: completion)
            }else {
                return
            }
        }
        
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        database.child("users").child(userUID).child("appointments").observe(.value, with: {snapshot in
            guard let _ = snapshot.value else {return}
            self.getAppointments(completion: completion)
        })
        

    }
    

    
    private func getAppointments(completion: @escaping (([Appointment]) -> () )){
        
        database.child("users").child(Auth.auth().currentUser!.uid).child("appointments").observeSingleEvent(of: .value, with: {snapshot in
            guard let appointments = snapshot.value as? NSMutableDictionary else {
                return
            }
            let appointmentArray =
            appointments.map{date, location in
                return Appointment(date: String(describing: date), location: String(describing: location))
            }
            completion(appointmentArray)
        })
    }
}
