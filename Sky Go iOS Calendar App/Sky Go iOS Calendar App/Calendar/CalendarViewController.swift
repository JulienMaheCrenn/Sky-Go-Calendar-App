//
//  HomeViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 09/02/2023.
//

import UIKit
import FirebaseDatabase
import DropDown

class CalendarViewController: UIViewController, CalendarPresenterDelegate, WeeklyViewDelegate{

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let selectDateButton = UIButton()
    let showProfileButton = UIBarButtonItem()
    
    let dateSelectionText = UITextField()
    let datePicker = UIDatePicker()
    
    let locationDropDownButton = UIButton()
    let locationDropDown = DropDown()
    
    
    let weeklyView =  WeeklyView()
    
    
    let userListView = UserListView()
    let userAPI = UserAPI()
        
    var presenter: CalendarPresenter
    
    init (userUID: String, database:DatabaseReference) {
        presenter = CalendarPresenter(userUID: userUID, database: database)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        weeklyView.delegate = self
        view.backgroundColor = .systemBackground
        
        setupWeekView()
        setupLocationDropDown()
        setupUserListView()
        
        //Dropdown Updater
        presenter.updateLocation()
        
        //Month label initialiser
        presenter.viewDidLoad()
    }
    
    func setupWeekView() {
        view.addSubview(weeklyView)
        
        weeklyView.layer.cornerRadius = 5
        
        weeklyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weeklyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weeklyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weeklyView.widthAnchor.constraint(equalTo:view.widthAnchor, multiplier: 0.95),
            weeklyView.bottomAnchor.constraint(equalTo:weeklyView.weeklyStackView.bottomAnchor),
        ])
    }
    
    func setupUserListView() {
        view.addSubview(userListView)
        
        userListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userListView.topAnchor.constraint(equalTo: locationDropDownButton.bottomAnchor, constant: 10),
            userListView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userListView.widthAnchor.constraint(equalTo: view.widthAnchor),
            userListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func setupLocationDropDown() {
        view.addSubview(locationDropDownButton)

        locationDropDownButton.configuration = .plain()
        locationDropDownButton.configuration?.titleAlignment = .center
        locationDropDownButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationDropDownButton.configuration?.imagePlacement = .trailing

        locationDropDown.anchorView = locationDropDownButton
        locationDropDown.dataSource = ["Osterley", "Leeds", "Brentwood"]
        locationDropDown.direction = .any

        locationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.locationDropDownButton.configuration?.title = "\(item)   "
        }

        locationDropDownButton.addTarget(self, action: #selector(handleLocationDropDown), for: .touchUpInside)

        locationDropDownButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            locationDropDownButton.topAnchor.constraint(equalTo: weeklyView.bottomAnchor, constant: 10),
            locationDropDownButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationDropDownButton.widthAnchor.constraint(equalTo: weeklyView.monthLabel.widthAnchor, multiplier: 0.75),
            locationDropDownButton.heightAnchor.constraint(equalToConstant: 30),
        ])

    }
    
    
    @objc func handleLocationDropDown () {
        locationDropDown.show()
    }
    
    
    func setupTextFields() {
        
        dateSelectionText.borderStyle = .roundedRect
        dateSelectionText.backgroundColor = .systemOrange
        dateSelectionText.textAlignment = .center
        dateSelectionText.textColor = .black
        
    }
    
    func updateLocation(location: String) {
        self.locationDropDownButton.configuration?.title = location
    }

//    func setupButtons() {
//
//
//        selectDateButton.configuration = .filled()
//        selectDateButton.configuration?.baseBackgroundColor = .systemPink
//        selectDateButton.configuration?.baseForegroundColor = .black
//        selectDateButton.configuration?.title = "Book Selected Office Day"
//        selectDateButton.configuration?.titleAlignment = .center
//
//
//        selectDateButton.addTarget(self, action: #selector(handleOfficeDayBooking), for: .touchUpInside)
//
//
//    }
    
    
    func setWeekView(withDates: [Date]) {
        weeklyView.buttonArray.enumerated().forEach { index, button in
            button.configuration?.title = String(describing:presenter.dayOfMonth(date: withDates[index]))
        }
    }
    
    func updateDateSelection(index: Int, selected: Bool) {
        let backgroundColour: UIColor = selected ? .red : .blue
        weeklyView.buttonArray[index].configuration?.baseBackgroundColor = backgroundColour
    }
    
    func dateButtonClicked(index: Int) {
        presenter.dateButtonClicked(index: index)
    }
    
    func forwardWeekButtonClicked() {
        presenter.forwardWeekButtonClicked()
    }
    
    func backwardWeekButtonClicked() {
        presenter.backwardWeekButtonClicked()
    }
    
    func updateMonthLabel(month: String) {
        weeklyView.monthLabel.text = month
    }

    
//    @objc func handleOfficeDayBooking() {
//
//
//        let officeDate = dateSelectionText.text!
//        let userId = (Auth.auth().currentUser?.uid)!
//        let appointmentUser: [String:Any] = ["\(userId)": true]
//
//
//        if Auth.auth().currentUser != nil {
//            database.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {snapshot in
//                                guard let value = snapshot.value as? NSObject else {
//                                    return
//                                }
//
//                let location = value.value(forKey: "location") as! String
//                let userAppointment: [String:Any] = ["\(officeDate)": "\(location)"]
//
//                self.database.child("appointments").child(officeDate).child(location).updateChildValues(appointmentUser)
//                self.database.child("users").child(userId).child("appointments").updateChildValues(userAppointment)
//                            })
//
//        } else {
//            return
//        }
//    }

}
