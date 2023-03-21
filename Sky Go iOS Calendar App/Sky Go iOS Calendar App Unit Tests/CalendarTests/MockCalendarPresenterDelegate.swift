//
//  CalendarPresenterDelegate.swift
//  Sky Go iOS Calendar App Unit Tests
//
//  Created by Julien Mahe-Crenn on 16/03/2023.
//

import Foundation
@testable import Sky_Go_iOS_Calendar_App

class MockCalendarPresenterDelegate:CalendarPresenterDelegate {
    
    var location:String = ""
    var userArray:[User] = []
    var alertMessage:String = ""
    
    func updateLocation(location: String) {
        self.location = location
    }
    
    func updateMonthLabel(month: String) {
        
    }
    
    func setWeekView(withDates: [Date]) {
        
    }
    
    func updateDateSelection(index: Int, selected: Bool) {
        
    }
    
    func reloadUserTableView(users: [User]) {
        self.userArray = users
    }
    
    func presentAlertModal(messageText: String) {
        self.alertMessage = messageText
    }
    
    
}
