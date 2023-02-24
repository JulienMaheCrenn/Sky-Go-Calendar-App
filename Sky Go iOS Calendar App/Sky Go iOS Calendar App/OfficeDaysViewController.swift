//
//  OfficeDaysViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 17/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OfficeDaysViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    let appointmentAPI = AppointmentAPI()
    let appointmentsTableView = UITableView()
    var appointmentsArray: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setupTableView()
        
        Auth.auth().addStateDidChangeListener{auth, user in
            if Auth.auth().currentUser != nil {
                self.setupAppointments()
            }else {
                return
            }
        }
        
        database.child("users").child(Auth.auth().currentUser!.uid).child("appointments").observe(.value, with: {snapshot in
            guard let _ = snapshot.value else {return}
            self.setupAppointments()
        })
        
    }
    
    func setupTableView() {
        view.addSubview(appointmentsTableView)
        
        appointmentsTableView.dataSource = self
        appointmentsTableView.delegate = self
        appointmentsTableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: "appointmentCell")
        
        
        appointmentsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appointmentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            appointmentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appointmentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appointmentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentTableViewCell
        cell.appointment = appointmentsArray[indexPath.row]
        return cell
    }
    
    func setupAppointments () {
        appointmentAPI.getAppointments(completion: {appointments in
            self.appointmentsArray = appointments
            
            self.appointmentsTableView.reloadData()
        })
    }

}
