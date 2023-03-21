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
    
    func testMonthLabelStringFormatterWorks() {
        let marchDate = Date(timeIntervalSince1970: 1679268918) //19th March 2023
        let expectedMonthLabel = "March 2023"
        let actualMonthLabel = sut.monthLabelString(date: marchDate)
        XCTAssertEqual(actualMonthLabel, expectedMonthLabel)
    }
    
    func testFullDateFormatterWorks() {
        let marchDate = Date(timeIntervalSince1970: 1679268918) //19th March 2023
        let expectedFullDateString = "19 March 2023"
        let actualFullDateString = sut.fullDateFormatter(date: marchDate)
        XCTAssertEqual(actualFullDateString, expectedFullDateString)
    }
    
    func testDayOfMonth() {
        let marchDate = Date(timeIntervalSince1970: 1679268918) //19th March 2023
        let expectedDayOfMonth = 19
        let actualDayOfMonth = sut.dayOfMonth(date: marchDate)
        XCTAssertEqual(actualDayOfMonth, expectedDayOfMonth)
    }
    
    func testDayOfWeekIntFormatterWorks() {
        let sundayDate = Date(timeIntervalSince1970: 1679268918) //19th March 2023
        let expectedWeekdayInteger = 1
        let actualWeekdayInteger = sut.weekDay(date: sundayDate)
        XCTAssertEqual(actualWeekdayInteger, expectedWeekdayInteger)
    }
    
    func testAddDaysFunctionWorks() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy"
        let sundayDate = Date(timeIntervalSince1970: 1679184000) //19th March 2023 at Midnight
        let expectedTwoDaysFutureDate = dateFormatter.date(from: "21-03-2023")
        let actualTwoDaysFutureDate = sut.addDays(date: sundayDate, days: 2)
        XCTAssertEqual(actualTwoDaysFutureDate, expectedTwoDaysFutureDate)
    }
    
    func testSundayForDateWorksOnSunday () {
        let sundayDate = Date(timeIntervalSince1970: 1679184000) //19th March 2023
        let actualSundayReturn = sut.sundayForDate(date: sundayDate)
        XCTAssertEqual(actualSundayReturn, sundayDate)
    }
    
    func testSundayForDateWorksOnNonSundayWeekday () {
        let sundayDate = Date(timeIntervalSince1970: 1679184000) // Sunday 19th March 2023
        let weekdayDate = Date(timeIntervalSince1970:1679529600) // Thursday 23 March 2023
        let actualSundayReturn = sut.sundayForDate(date:weekdayDate)
        XCTAssertEqual(actualSundayReturn, sundayDate)
    }
    
    func testGetUsersSucceeds () {
        let mockUserArray = [User(name: "Test User 1", jobTitle: "Associate Dev", department: "Sky Go", location: "Osterley"),
                             User(name: "Test User 2", jobTitle: "Senior Dev", department: "Sky Go", location: "Osterley"),
                             User(name: "Test User 3", jobTitle: "Senior Scrum Master", department: "Sky Go", location: "Osterley"),
                             User(name: "Test User 4", jobTitle: "QA Tester", department: "Sky Go", location: "Osterley")
        ]
        mockCalendarModel.mockGetUsersResult = .success(mockUserArray)
        sut.getUsers(date: "20 March 2023", location: "Osterley", department: "Sky Go")
        XCTAssertEqual(mockCalendarPresenterDelegate.userArray, mockUserArray)
    }
    
    func testGetUsersFails() {
        mockCalendarModel.mockGetUsersResult = .failure(.standard)
        sut.getUsers(date:"20 March 2023", location: "Osterley", department: "Sky Go")
        XCTAssertEqual(mockCalendarPresenterDelegate.alertMessage, "No users have booked into the office on this day.")
    }

}
