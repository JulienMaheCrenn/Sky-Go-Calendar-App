//
//  ProfileViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 15/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    private let database = Database.database(url: "https://sky-go-hybrid-calendar-app-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let fullNameLabel = UILabel()
    let jobTitleLabel = UILabel()
    let departmentLabel = UILabel()
    let locationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupLabels()
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20.0
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        
        [self.fullNameLabel,
         self.jobTitleLabel,
         self.departmentLabel,
         self.locationLabel,
        ].forEach {contentStackView.addArrangedSubview($0)}
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentStackView.widthAnchor.constraint(equalToConstant: 300),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func setupLabels() {
        fullNameLabel.backgroundColor = .systemOrange
        jobTitleLabel.backgroundColor = .systemOrange
        departmentLabel.backgroundColor = .systemOrange
        locationLabel.backgroundColor = .systemOrange
        
        fullNameLabel.textAlignment = .center
        jobTitleLabel.textAlignment = .center
        departmentLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        
        fullNameLabel.numberOfLines = 0
        jobTitleLabel.numberOfLines = 0
        departmentLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                self.database.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {snapshot in
                                    guard let value = snapshot.value as? NSObject else {
                                        self.fullNameLabel.text = "Unable to retrieve Data"
                                        return
                                    }
                    self.fullNameLabel.text = "Full Name: \(value.value(forKey: "name") ?? "Not Found")"
                    self.jobTitleLabel.text = "Job Title: \(value.value(forKey: "jobTitle") ?? "Not Found")"
                    self.departmentLabel.text = "Department: \(value.value(forKey: "department") ?? "Not Found")"
                    self.locationLabel.text = "Location: \(value.value(forKey: "location") ?? "Not Found")"
                                })
            } else {
                return
            }
        }
        
    }
}
