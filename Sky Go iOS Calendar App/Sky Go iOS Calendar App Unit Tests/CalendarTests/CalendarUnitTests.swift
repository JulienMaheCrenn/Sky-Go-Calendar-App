//
//  CalendarUnitTests.swift
//  Sky Go iOS Calendar App Unit Tests
//
//  Created by Julien Mahe-Crenn on 16/03/2023.
//

import XCTest
@testable import Sky_Go_iOS_Calendar_App
import FirebaseDatabase

final class CalendarUnitTests: XCTestCase {
    
    private var mockCalendarPresenterDelegate: MockCalendarPresenterDelegate!
    private var mockCalendarModel: MockCalendarModel!
    private var sut: CalendarPresenter!
    
    private var mockDatabaseReference:DatabaseReference!
    private var mockUser:User!

    override func setUp() {
        mockUser = User(name: "Felicity Flop", jobTitle: "Developer", department: "Sky Go", location: "Osterley")
        mockCalendarPresenterDelegate = MockCalendarPresenterDelegate()
        mockCalendarModel = MockCalendarModel()
        sut = CalendarPresenter(userUID: "", user: mockUser, model: mockCalendarModel)
        sut.delegate = mockCalendarPresenterDelegate
    }

    override func tearDown(){
        mockDatabaseReference = nil
        mockUser = nil
        mockCalendarPresenterDelegate = nil
        mockCalendarModel = nil
        sut = nil
    }

    func testUpdateLocationSuccess() {
        mockCalendarModel.mockUpdateUserLocationResult = .success("Leeds")
        sut.updateLocation()
        XCTAssertEqual(mockCalendarPresenterDelegate.location, "Leeds")
    }

    func testUpdateLocationFailure() {
        mockCalendarModel.mockUpdateUserLocationResult = .failure(.standard)
        sut.updateLocation()
        XCTAssertEqual(mockCalendarPresenterDelegate.location, "Not Found")
    }

}
