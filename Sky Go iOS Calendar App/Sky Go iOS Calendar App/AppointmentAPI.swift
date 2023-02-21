//
//  AppointmentAPI.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 17/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppointmentAPI {
    
    let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    func getAppointments(completion: @escaping (([Appointment]) -> () )){
        
        database.child("users").child(Auth.auth().currentUser!.uid).child("appointments").observeSingleEvent(of: .value, with: {snapshot in
            guard let appointments = snapshot.value as? NSMutableDictionary else {
                return
            }
            let appointmentArray =
            appointments.map{date, location in
                return Appointment(date: String(String(describing: date)), location: String(describing: location))
            }
            completion(appointmentArray)
        })
    }}
