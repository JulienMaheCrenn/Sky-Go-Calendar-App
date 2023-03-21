//
//  CalendarPresenter.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 03/03/2023.
//

import Foundation
import FirebaseDatabase

protocol CalendarPresenterDelegate: AnyObject {
    func updateLocation(location:String)
    
    //WeeklyView Delegate Methods
    func updateMonthLabel (month: String)
    func setWeekView (withDates: [Date])
    func updateDateSelection (index:Int, selected:Bool)
    
    //UserListView Delegate Methods
    func reloadUserTableView(users:[User])
    
    func presentAlertModal(messageText:String)
}


class CalendarPresenter {
    
    private let calendar = Calendar.current
    private let calendarModel: CalendarModelProtocol
    weak var delegate:CalendarPresenterDelegate?
    private var currentlyDisplayedDates: [Date]
    private var currentlySelectedDateIndex: Int = 0
    private var currentlyDisplayedUsers: [User]
    private var currentlySelectedLocation: String
    private var user: User
    
    init (userUID:String, user:User, model:CalendarModelProtocol) {
        calendarModel = model
        currentlyDisplayedDates = []
        currentlyDisplayedUsers = []
        self.user = user
        self.currentlySelectedLocation = user.location
        currentlySelectedDateIndex = weekDay(date: Date())-1
    }
    
    func viewDidLoad () {
        //Month Label Initialiser
        let month = monthLabelString(date: Date())
        delegate?.updateMonthLabel(month: month)
        
        //Date Buttons Labels Initialiser
        let sunday = sundayForDate(date: Date())
        currentlyDisplayedDates.append(sunday)
        (0..<6).forEach { position in
            let nextDay = addDays(date: sunday, days: position+1)
            currentlyDisplayedDates.append(nextDay)
        }
        delegate?.setWeekView(withDates: currentlyDisplayedDates)
        
        //Date Selection Initialiser
        delegate?.updateDateSelection(index: currentlySelectedDateIndex, selected: true)
        
        //User List Initialiser
        calendarModel.getUsers(date: fullDateFormatter(date: Date()), location: currentlySelectedLocation, department: user.department, completion: {result in
            switch result {
            case .success(let userArray):
                self.currentlyDisplayedUsers = userArray
                self.delegate?.reloadUserTableView(users: userArray)
            case .failure:
                self.delegate?.presentAlertModal(messageText: "No users have booked into the office on this day.")
            }
        })
    }
    
    func handleOfficeDayBooking () {
        calendarModel.handleOfficeDayBooking(date: fullDateFormatter(date: currentlyDisplayedDates[currentlySelectedDateIndex]),
                                             location: currentlySelectedLocation,
                                             department: user.department,
                                             completion: {result in
            switch result {
            case .success(let alertText):
                self.delegate?.presentAlertModal(messageText: alertText)
                self.getUsers(date: self.fullDateFormatter(date: self.currentlyDisplayedDates[self.currentlySelectedDateIndex]), location: self.currentlySelectedLocation, department: self.user.department)

            case .failure:
                return
            }})
    }
    
    func locationChanged(location:String) {
        self.currentlySelectedLocation = location
        getUsers(date: fullDateFormatter(date: currentlyDisplayedDates[currentlySelectedDateIndex]), location: currentlySelectedLocation, department: user.department)
    }
    
    func dateButtonClicked (index: Int) {
        delegate?.updateDateSelection(index: currentlySelectedDateIndex, selected: false)
        currentlySelectedDateIndex = index
        delegate?.updateDateSelection(index: currentlySelectedDateIndex, selected: true)
        let month = monthLabelString(date: currentlyDisplayedDates[index])
        delegate?.updateMonthLabel(month: month)
        getUsers(date: fullDateFormatter(date: currentlyDisplayedDates[index]), location: currentlySelectedLocation, department: user.department)
    }
    
    func forwardWeekButtonClicked() {
       currentlyDisplayedDates = currentlyDisplayedDates.map{
            addDays(date: $0, days: 7)
        }
        delegate?.setWeekView(withDates: currentlyDisplayedDates)
        let month = monthLabelString(date: currentlyDisplayedDates[currentlySelectedDateIndex])
        delegate?.updateMonthLabel(month: month)
        getUsers(date: fullDateFormatter(date: currentlyDisplayedDates[currentlySelectedDateIndex]), location: currentlySelectedLocation, department: user.department)
    }
    
    func backwardWeekButtonClicked() {
        currentlyDisplayedDates = currentlyDisplayedDates.map{
             addDays(date: $0, days: -7)
         }
        delegate?.setWeekView(withDates: currentlyDisplayedDates)
        let month = monthLabelString(date: currentlyDisplayedDates[currentlySelectedDateIndex])
        delegate?.updateMonthLabel(month: month)
        getUsers(date: fullDateFormatter(date: currentlyDisplayedDates[currentlySelectedDateIndex]), location: currentlySelectedLocation, department: user.department)
    }
    
    func getUsers(date:String, location:String, department:String) {
        calendarModel.getUsers(date: date, location: location, department: department, completion: {result in
            switch result {
            case .success(let userArray):
                self.delegate?.reloadUserTableView(users: userArray)
            case .failure:
                return
            }
        })
    }
    
    func updateLocation () {
        calendarModel.updateUserLocation { result in
            switch result {
            case .success(let location):
                self.delegate?.updateLocation(location: location)
            case .failure:
                self.delegate?.updateLocation(location: "Not Found")
            }
        }
    }
    
    func populateLocationDropdown() -> [String] {
        calendarModel.populateLocationDropdown()
    }
    
    //Calendar Date formattingn functions:
    func monthLabelString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func fullDateFormatter (date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func dayOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func weekDay (date:Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday ?? 000
    }

    func addDays(date: Date, days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: date) ?? Date()
    }
    
    func sundayForDate(date:Date) -> Date {
        let current = date
        let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
        if(currentWeekDay == 1){
            return current
        }

        var oneWeekAgo = addDays(date: current, days: -7)

        while (current > oneWeekAgo) {
            let currentWeekDay = calendar.dateComponents([.weekday], from: oneWeekAgo).weekday
            if(currentWeekDay == 1){
                return oneWeekAgo
            }

            oneWeekAgo = addDays(date: oneWeekAgo, days: 1)
        }
        return current
    }
}
