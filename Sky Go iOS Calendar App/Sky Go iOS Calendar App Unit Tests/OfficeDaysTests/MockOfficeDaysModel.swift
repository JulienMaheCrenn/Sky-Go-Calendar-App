//
//  MockOfficeDaysModel.swift
//  Sky Go iOS Calendar App Unit Tests
//
//  Created by Julien Mahe-Crenn on 16/03/2023.
//

import Foundation
@testable import Sky_Go_iOS_Calendar_App


class MockOfficeDaysModel: OfficeDaysModelProtocol {
    
    var mockData: [Appointment] = []
    
    func setupAppointmentsListener(completion: @escaping (([Appointment]) -> ())) {
        completion(mockData)
    }
    
    func configureMockData (withData mockData:[Appointment]) {
        self.mockData = mockData
    }
}
