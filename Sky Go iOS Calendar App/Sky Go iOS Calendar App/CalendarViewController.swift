//
//  HomeViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 09/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown

class CalendarViewController: UIViewController, WeeklyViewDelegate{

    

    
    
    let database = Database.database(url:"https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()

    var currentUserUID = Auth.auth().currentUser?.uid
    
    let selectDateButton = UIButton()
    let showProfileButton = UIBarButtonItem()
    
    let dateSelectionText = UITextField()
    let datePicker = UIDatePicker()
    
    let locationDropDownButton = UIButton()
    let locationDropDown = DropDown()
    
    
    lazy var weeklyView =  WeeklyView(delegate: self)
    
    var currentlyDisplayedDates: [Date] = []
    var currentlySelectedDateIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiallyDisplayedDates()
        currentlySelectedDateIndex = WeeklyCalendarHelper().weekDay(date: Date())-1
        weeklyView.updateDateSelection(index: currentlySelectedDateIndex, selected: true)

        view.backgroundColor = .systemBackground
        
        setupWeekView()
        setupLocationDropDown()
        
        //Dropdown Updater
        
        Auth.auth().addStateDidChangeListener{auth, user in
            self.currentUserUID = Auth.auth().currentUser?.uid
            self.updateUserLocation()
        }
    }
    
    func initiallyDisplayedDates () {
        let sunday = WeeklyCalendarHelper().sundayForDate(date: Date())
        currentlyDisplayedDates.append(sunday)
        (0..<6).forEach { position in
            let nextDay = WeeklyCalendarHelper().addDays(date: sunday, days: position+1)
            currentlyDisplayedDates.append(nextDay)
        }
        weeklyView.setWeekView(withDates: currentlyDisplayedDates)
    }

    
    
//    func setupDatePicker() {
//        datePicker.datePickerMode = .date
//        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
//        datePicker.frame.size = CGSize(width: 0, height: 300)
//        datePicker.minimumDate = Date()
//        datePicker.preferredDatePickerStyle = .wheels
//
//        dateSelectionText.inputView = datePicker
//
//        dateSelectionText.text = formatDateToString(date: Date())
//
//    }
//
//    @objc func dateChange(datePicker:UIDatePicker) {
//        dateSelectionText.text = formatDateToString(date: datePicker.date)
//    }
//
//    func formatDateToString(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM yyyy"
//        return formatter.string(from: date)
//    }
    
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
    
    
    func setupLocationDropDown() {
        view.addSubview(locationDropDownButton)

        locationDropDownButton.configuration = .plain()
        locationDropDownButton.configuration?.titleAlignment = .center
        locationDropDownButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationDropDownButton.configuration?.imagePlacement = .trailing

        database.child("users").child(currentUserUID!).observeSingleEvent(of: .value, with: {snapshot in
            guard let user = snapshot.value as? NSObject else{
                self.locationDropDownButton.configuration?.title = "Error finding location"
                return
            }

            self.locationDropDownButton.configuration?.title = "\(user.value(forKey: "location") as? String ?? "location not found")  "

        })

        locationDropDown.anchorView = locationDropDownButton
        locationDropDown.dataSource = ["Osterley  ", "Leeds  ", "Brentwood  "]
        locationDropDown.direction = .any

        locationDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.locationDropDownButton.configuration?.title = "\(item)"
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
    
    func updateUserLocation () {
        if Auth.auth().currentUser != nil {
            self.database.child("users").child(self.currentUserUID!).observeSingleEvent(of: .value, with: {snapshot in
                guard let user = snapshot.value as? NSObject else{
                    self.locationDropDownButton.configuration?.title = "Error finding location"
                    return
                }
                self.locationDropDownButton.configuration?.title = "\(user.value(forKey: "location") as? String ?? "location not found")  "
            })
        }else {
            return
        }
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

    func setupButtons() {

        
        selectDateButton.configuration = .filled()
        selectDateButton.configuration?.baseBackgroundColor = .systemPink
        selectDateButton.configuration?.baseForegroundColor = .black
        selectDateButton.configuration?.title = "Book Selected Office Day"
        selectDateButton.configuration?.titleAlignment = .center
        

        selectDateButton.addTarget(self, action: #selector(handleOfficeDayBooking), for: .touchUpInside)
    
        
    }
    
    func dateButtonClicked(index: Int) {
        weeklyView.updateDateSelection(index: currentlySelectedDateIndex, selected: false)
        currentlySelectedDateIndex = index
        weeklyView.updateDateSelection(index: currentlySelectedDateIndex, selected: true)
        let month = WeeklyCalendarHelper().monthLabelString(date: currentlyDisplayedDates[index])
        weeklyView.updateMonthLabel(month: month)
        print("\(WeeklyCalendarHelper().fullDateFormatter(date: currentlyDisplayedDates[index]))")
    }
    
    func forwardWeekButtonClicked() {
       currentlyDisplayedDates = currentlyDisplayedDates.map{
            WeeklyCalendarHelper().addDays(date: $0, days: 7)
        }
        weeklyView.setWeekView(withDates: currentlyDisplayedDates)
        let month = WeeklyCalendarHelper().monthLabelString(date: currentlyDisplayedDates[currentlySelectedDateIndex])
        weeklyView.updateMonthLabel(month: month)
    }
    
    func backwardWeekButtonClicked() {
        currentlyDisplayedDates = currentlyDisplayedDates.map{
             WeeklyCalendarHelper().addDays(date: $0, days: -7)
         }
        weeklyView.setWeekView(withDates: currentlyDisplayedDates)
        let month = WeeklyCalendarHelper().monthLabelString(date: currentlyDisplayedDates[currentlySelectedDateIndex])
        weeklyView.updateMonthLabel(month: month)
    }

//    @objc func handleShowProfile () {
//        let profileView = ProfileViewController()
//        present(profileView, animated: true)
//    }
    
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
