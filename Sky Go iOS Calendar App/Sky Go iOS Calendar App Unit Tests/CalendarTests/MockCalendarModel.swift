//
//  MockCalendarModel.swift
//  Sky Go iOS Calendar App Unit Tests
//
//  Created by Julien Mahe-Crenn on 16/03/2023.
//

import Foundation
@testable import Sky_Go_iOS_Calendar_App

class MockCalendarModel: CalendarModelProtocol {
    
    var mockGetUsersResult:Result<[User], FirebaseError> = .failure(.standard)
    var mockHandleOfficeDayBookingResult: Result<String, FirebaseError> = .failure(.standard)
    var mockUpdateUserLocationResult: Result<String, FirebaseError> = .failure(.standard)
    var mockPopulateLocationDropdown: [String] = []
    
    func getUsers(date: String, location: String, department: String, completion: @escaping (Result<[User], FirebaseError>) -> ()) {
        completion(mockGetUsersResult)
    }
    
    func handleOfficeDayBooking(date: String, location: String, department: String, completion: @escaping ((Result<String, FirebaseError>) -> ())) {
        completion(mockHandleOfficeDayBookingResult)
    }
    
    func updateUserLocation(completion: @escaping (Result<String, FirebaseError>) -> ()) {
        completion(mockUpdateUserLocationResult)
    }
    
    func populateLocationDropdown() -> [String] {
        return mockPopulateLocationDropdown
    }
    

    
}
