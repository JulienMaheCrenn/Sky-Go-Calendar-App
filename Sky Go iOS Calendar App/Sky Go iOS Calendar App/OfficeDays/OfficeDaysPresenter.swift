//
//  OfficeDaysPresenter.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 02/03/2023.
//

import Foundation

protocol OfficeDaysPresenterDelegate: AnyObject{
    func reloadTableView (appointments:[Appointment])
}

struct OfficeDaysPresenter {
    
    private let officeDaysModel = OfficeDaysModel()
    weak var delegate:OfficeDaysPresenterDelegate?
    
    func viewDidLoad () {
        officeDaysModel.setupAppointmentsListener(completion: {appointments in
            self.delegate?.reloadTableView(appointments: appointments)
        })
    }
}
