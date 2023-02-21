//
//  HomeViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 09/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController {
    
    let database = Database.database(url:"https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let selectDateButton = UIButton()
    let showProfileButton = UIButton()
    let logOutButton = UIButton()
    let dateSelectionLabel = UILabel()
    let dateSelectionText = UITextField()
    let datePicker = UIDatePicker()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        setupScrollView()
        setupViews()

    }
    
    func setupViews() {
        setupDatePicker()
        setupLabels()
        setupTextFields()
        setupButtons()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        contentStackView.axis = .vertical
        contentStackView.spacing = 20.0
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually

        [self.dateSelectionLabel,
         self.dateSelectionText,
         self.selectDateButton,
         self.showProfileButton,
         self.logOutButton,
        ].forEach {contentStackView.addArrangedSubview($0)}

        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentStackView.widthAnchor.constraint(equalToConstant: 300),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        
        dateSelectionText.inputView = datePicker
        
        dateSelectionText.text = formatDateToString(date: Date())

    }
    
    @objc func dateChange(datePicker:UIDatePicker) {
        dateSelectionText.text = formatDateToString(date: datePicker.date)
    }
    
    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func setupLabels() {

        
        dateSelectionLabel.text = "Choose a date:"
        dateSelectionLabel.textAlignment = .center
        dateSelectionLabel.backgroundColor = .systemOrange
        dateSelectionLabel.textColor = .black
        
    }
    
    func setupTextFields() {
        
        dateSelectionText.borderStyle = .roundedRect
        dateSelectionText.backgroundColor = .systemOrange
        dateSelectionText.textAlignment = .center
        dateSelectionText.textColor = .black
        
    }

    func setupButtons() {

        
        selectDateButton.configuration = .filled()
        selectDateButton.configuration?.baseBackgroundColor = .systemPink
        selectDateButton.configuration?.baseForegroundColor = .black
        selectDateButton.configuration?.title = "Book Selected Office Day"
        selectDateButton.configuration?.titleAlignment = .center
        
        logOutButton.configuration = .filled()
        logOutButton.configuration?.baseBackgroundColor = .systemRed
        logOutButton.configuration?.title = "Log Out"
        logOutButton.configuration?.baseForegroundColor = .black
        
        showProfileButton.configuration = .filled()
        showProfileButton.configuration?.baseBackgroundColor = .systemGreen
        showProfileButton.configuration?.baseForegroundColor = .white
        showProfileButton.configuration?.title = "Show Profile"
        
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        showProfileButton.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        selectDateButton.addTarget(self, action: #selector(handleOfficeDayBooking), for: .touchUpInside)
    
        
    }
    
    @objc func handleLogOut() {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @objc func handleShowProfile () {
        let profileView = ProfileViewController()
        present(profileView, animated: true)
    }
    
    @objc func handleOfficeDayBooking() {
        
        
        let officeDate = dateSelectionText.text!
        let userId = (Auth.auth().currentUser?.uid)!
        let appointmentUser: [String:Any] = ["\(userId)": true]

        
        if Auth.auth().currentUser != nil {
            database.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {snapshot in
                                guard let value = snapshot.value as? NSObject else {
                                    return
                                }
    
                let location = value.value(forKey: "location") as! String
                let userAppointment: [String:Any] = ["\(officeDate)": "\(location)"]
                
                self.database.child("appointments").child(officeDate).child(location).updateChildValues(appointmentUser)
                self.database.child("users").child(userId).child("appointments").updateChildValues(userAppointment)
                            })

        } else {
            return
        }


    }

}
