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
    func dateButtonClicked (index: Int)
    func forwardWeekButtonClicked ()
    func backwardWeekButtonClicked ()
    func updateMonthLabel (month: String)
    func setWeekView (withDates: [Date])
    func updateDateSelection (index:Int, selected:Bool)
}


struct CalendarPresenter {
    
    private let calendarModel: CalendarModel
    weak var delegate:CalendarPresenterDelegate?
    var currentlyDisplayedDates: [Date]
    var currentlySelectedDateIndex: Int
    
    init (userUID:String, database:DatabaseReference) {
        calendarModel = CalendarModel(userUID: userUID, database: database)
        currentlyDisplayedDates = []
        currentlySelectedDateIndex = WeeklyCalendarHelper().weekDay(date: Date())-1
    }
    
    mutating func viewDidLoad () {
        //Month Label Initialiser
        let month = WeeklyCalendarHelper().monthLabelString(date: Date())
        delegate?.updateMonthLabel(month: month)
        
        //Date Buttons Labels Initialiser
        let sunday = WeeklyCalendarHelper().sundayForDate(date: Date())
        currentlyDisplayedDates.append(sunday)
        (0..<6).forEach { position in
            let nextDay = WeeklyCalendarHelper().addDays(date: sunday, days: position+1)
            currentlyDisplayedDates.append(nextDay)
        }
        delegate?.setWeekView(withDates: currentlyDisplayedDates)
        
        //Date Selection Initialiser
        delegate?.updateDateSelection(index: currentlySelectedDateIndex, selected: true)
    }
    
    mutating func dateButtonClicked (index: Int) {
        delegate?.updateDateSelection(index: currentlySelectedDateIndex, selected: false)
        currentlySelectedDateIndex = index
        delegate?.updateDateSelection(index: currentlySelectedDateIndex, selected: true)
        let month = WeeklyCalendarHelper().monthLabelString(date: currentlyDisplayedDates[index])
        delegate?.updateMonthLabel(month: month)
//        userAPI.getUsers(date: "\(WeeklyCalendarHelper().fullDateFormatter(date: currentlyDisplayedDates[index]))",
//                         location: "Osterley")
    }
    
    mutating func forwardWeekButtonClicked() {
       currentlyDisplayedDates = currentlyDisplayedDates.map{
            WeeklyCalendarHelper().addDays(date: $0, days: 7)
        }
        delegate?.setWeekView(withDates: currentlyDisplayedDates)
        let month = WeeklyCalendarHelper().monthLabelString(date: currentlyDisplayedDates[currentlySelectedDateIndex])
        delegate?.updateMonthLabel(month: month)
    }
    
    mutating func backwardWeekButtonClicked() {
        currentlyDisplayedDates = currentlyDisplayedDates.map{
             WeeklyCalendarHelper().addDays(date: $0, days: -7)
         }
        delegate?.setWeekView(withDates: currentlyDisplayedDates)
        let month = WeeklyCalendarHelper().monthLabelString(date: currentlyDisplayedDates[currentlySelectedDateIndex])
        delegate?.updateMonthLabel(month: month)
    }
    
    func updateLocation () {
        calendarModel.updateUserLocation { result in
            switch result {
            case .success(let location):
                delegate?.updateLocation(location: location)
            case .failure:
                delegate?.updateLocation(location: "Not Found")
            }
        }
    }
}
