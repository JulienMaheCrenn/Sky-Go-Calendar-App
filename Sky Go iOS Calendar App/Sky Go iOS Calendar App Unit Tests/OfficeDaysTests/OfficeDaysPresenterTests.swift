//
//  Sky_Go_iOS_Calendar_App_Unit_Tests.swift
//  Sky Go iOS Calendar App Unit Tests
//
//  Created by Julien Mahe-Crenn on 16/03/2023.
//

import XCTest
@testable import Sky_Go_iOS_Calendar_App

class OfficeDaysPresenterTests: XCTestCase {

    private var mockOfficeDaysModel: MockOfficeDaysModel!
    private var sut: OfficeDaysPresenter!
    
    override func setUp() {
        mockOfficeDaysModel = MockOfficeDaysModel()
        sut = OfficeDaysPresenter(officeDaysModel: mockOfficeDaysModel, today: Date(timeIntervalSince1970: 1678978446))
    }

    override func tearDown() {
        mockOfficeDaysModel = nil
        sut = nil
    }

    func testExample() throws {
        XCTAssertTrue(true)
    }

    func testOnlyPastAppointments() throws {
        mockOfficeDaysModel.configureMockData(withData: [Appointment(date: "22 February 2023", location: "Osterley"),
                                                         Appointment(date: "13 August 2021", location: "Leeds"),
                                                         Appointment(date: "2 January 2022", location: "Brentwood"),
                                                         Appointment(date: "18 November 2022", location: "Osterley"),
                                                         Appointment(date: "10 February 1999", location: "Osterley")
                                                        ])
        
        let expectedPastArray = [Appointment(date: "22 February 2023", location: "Osterley"),
                                 Appointment(date: "18 November 2022", location: "Osterley"),
                                 Appointment(date: "2 January 2022", location: "Brentwood"),
                                 Appointment(date: "13 August 2021", location: "Leeds"),
                                 Appointment(date: "10 February 1999", location: "Osterley")
                                ]
        
        sut.viewDidLoad()
        XCTAssertEqual(sut.pastAppointments, expectedPastArray)
        XCTAssertEqual(sut.futureAppointments, [])
    }
    
    func testOnlyFutureAppointments() throws {
        mockOfficeDaysModel.configureMockData(withData: [Appointment(date: "22 February 2024", location: "Osterley"),
                                                         Appointment(date: "13 August 2023", location: "Leeds"),
                                                         Appointment(date: "2 January 2080", location: "Brentwood"),
                                                         Appointment(date: "18 November 2063", location: "Osterley"),
                                                         Appointment(date: "10 February 3004", location: "Osterley")
                                                        ])
        
        let expectedFutureArray = [Appointment(date: "13 August 2023", location: "Leeds"),
                                 Appointment(date: "22 February 2024", location: "Osterley"),
                                 Appointment(date: "18 November 2063", location: "Osterley"),
                                 Appointment(date: "2 January 2080", location: "Brentwood"),
                                 Appointment(date: "10 February 3004", location: "Osterley")
                                ]
        
        sut.viewDidLoad()
        XCTAssertEqual(sut.futureAppointments, expectedFutureArray)
        XCTAssertEqual(sut.pastAppointments, [])
    }
    
    func testFutureAndPastAppointments() throws {
        mockOfficeDaysModel.configureMockData(withData: [Appointment(date: "22 February 2024", location: "Osterley"),
                                                         Appointment(date: "13 August 2023", location: "Leeds"),
                                                         Appointment(date: "2 January 2080", location: "Brentwood"),
                                                         Appointment(date: "18 November 2022", location: "Osterley"),
                                                         Appointment(date: "10 February 3004", location: "Osterley"),
                                                         Appointment(date: "22 February 2023", location: "Osterley"),
                                                         Appointment(date: "13 August 2021", location: "Leeds"),
                                                         Appointment(date: "2 January 2022", location: "Brentwood"),
                                                         Appointment(date: "10 February 1999", location: "Osterley"),
                                                         Appointment(date: "18 November 2063", location: "Osterley")

                                                        ])
        
        let expectedPastArray = [Appointment(date: "22 February 2023", location: "Osterley"),
                                 Appointment(date: "18 November 2022", location: "Osterley"),
                                 Appointment(date: "2 January 2022", location: "Brentwood"),
                                 Appointment(date: "13 August 2021", location: "Leeds"),
                                 Appointment(date: "10 February 1999", location: "Osterley")
                                ]
        
        let expectedFutureArray = [Appointment(date: "13 August 2023", location: "Leeds"),
                                 Appointment(date: "22 February 2024", location: "Osterley"),
                                 Appointment(date: "18 November 2063", location: "Osterley"),
                                 Appointment(date: "2 January 2080", location: "Brentwood"),
                                 Appointment(date: "10 February 3004", location: "Osterley")
                                ]
        
        sut.viewDidLoad()
        XCTAssertEqual(sut.futureAppointments, expectedFutureArray)
        XCTAssertEqual(sut.pastAppointments, expectedPastArray)
    }
    
    func testNoAppointments () {
        mockOfficeDaysModel.configureMockData(withData: [])
        
        sut.viewDidLoad()
        XCTAssertEqual(sut.futureAppointments, [])
        XCTAssertEqual(sut.pastAppointments, [])
    }

}
