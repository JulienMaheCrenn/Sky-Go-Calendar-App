//
//  OfficeDaysViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 17/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OfficeDaysViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OfficeDaysPresenterDelegate{

    

    let appointmentsTableView = UITableView()
    var appointmentsArray: [Appointment] = []
    var presenter = OfficeDaysPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        view.backgroundColor = .systemPurple
        setupTableView()
        presenter.viewDidLoad()

    }
    
    
    // Part of Office Days Delegate
    func reloadTableView(appointments:[Appointment]) {
        appointmentsArray = appointments
        appointmentsTableView.reloadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as? AppointmentTableViewCell else {fatalError("Uh OH")}
        cell.appointment = appointmentsArray[indexPath.row]
        return cell
    }
    


}
