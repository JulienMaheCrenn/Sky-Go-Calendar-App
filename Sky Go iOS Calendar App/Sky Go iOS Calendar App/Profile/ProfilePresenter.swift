//
//  ProfilePresenter.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 03/03/2023.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func reloadView (user: User)
    func reloadViewWithError (error: FirebaseError)
    func presentError(error: FirebaseError)
}

struct ProfilePresenter {
    private let profileModel: ProfileModel
    weak var delegate:ProfilePresenterDelegate?
    
    init (userUID:String) {
        profileModel = ProfileModel(userUID: userUID)
    }
    
    func viewDidLoad () {
        profileModel.setupUserListener(completion: {result in
            switch result {
            case .success(let user):
                let formattedUser = User(name: "Full Name: \(user.name)",
                                         jobTitle: "Job Title: \(user.jobTitle)",
                                         department: "Department: \(user.department)",
                                         location: "Location: \(user.location)")
                self.delegate?.reloadView(user: formattedUser)
            case .failure(let failure):
                self.delegate?.reloadViewWithError(error: failure)
            }
        })
    }
    
    func logOut () {
        profileModel.logOut(completion: {error in
            self.delegate?.presentError(error: error)
        })
    }
}
