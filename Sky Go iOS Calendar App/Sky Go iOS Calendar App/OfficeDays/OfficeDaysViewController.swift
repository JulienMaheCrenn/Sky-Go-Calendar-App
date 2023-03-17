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
    let futureButton = UIButton()
    let pastButton = UIButton()
    var appointmentsArray: [Appointment] = []
    var presenter = OfficeDaysPresenter(officeDaysModel: OfficeDaysModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        view.backgroundColor = .systemBackground
        setupFuturePastToggle()
        setupTableView()
        presenter.viewDidLoad()

    }
    
    
    // Part of Office Days Delegate
    func reloadTableView(appointments:[Appointment]) {
        appointmentsArray = appointments
        
        appointmentsTableView.reloadData()
    }
    
    func setupFuturePastToggle () {
        view.addSubview(pastButton)
        view.addSubview(futureButton)
        
        pastButton.configuration = .filled()
        futureButton.configuration = .filled()
        
        pastButton.configuration?.baseBackgroundColor = .systemBlue
        futureButton.configuration?.baseBackgroundColor = .systemRed
        
        pastButton.configuration?.baseForegroundColor = .white
        futureButton.configuration?.baseForegroundColor = .white
        
        pastButton.configuration?.title = "Past"
        futureButton.configuration?.title = "Future"
        
        pastButton.configuration?.titleAlignment = .center
        futureButton.configuration?.titleAlignment = .center
        
        pastButton.addTarget(self, action: #selector(pastButtonClicked), for: .touchUpInside)
        futureButton.addTarget(self, action: #selector(futureButtonClicked), for: .touchUpInside)

        pastButton.translatesAutoresizingMaskIntoConstraints = false
        futureButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pastButton.widthAnchor.constraint(equalToConstant: 100),
            pastButton.heightAnchor.constraint(equalToConstant: 30),
            pastButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pastButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            
            futureButton.widthAnchor.constraint(equalToConstant: 100),
            futureButton.heightAnchor.constraint(equalToConstant: 30),
            futureButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            futureButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
        ])
    }
    
    @objc func pastButtonClicked() {
        presenter.pastButtonClicked()
    }
    
    @objc func futureButtonClicked() {
        presenter.futureButtonClicked()
    }
    
    func togglePastButtonColour() {
        self.pastButton.configuration?.baseBackgroundColor = .systemRed
        self.futureButton.configuration?.baseBackgroundColor = .systemBlue
    }
    
    func toggleFutureButtonColour() {
        self.pastButton.configuration?.baseBackgroundColor = .systemBlue
        self.futureButton.configuration?.baseBackgroundColor = .systemRed
    }
    
    func setupTableView() {
        view.addSubview(appointmentsTableView)
        
        appointmentsTableView.dataSource = self
        appointmentsTableView.delegate = self
        appointmentsTableView.register(AppointmentTableViewCell.self, forCellReuseIdentifier: "appointmentCell")
        
        
        appointmentsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appointmentsTableView.topAnchor.constraint(equalTo: pastButton.bottomAnchor, constant: 20),
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
