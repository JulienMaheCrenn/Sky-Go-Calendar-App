//
//  ProfileViewController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 15/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, ProfilePresenterDelegate {

    

    let scrollView = UIScrollView()
    let contentStackView = UIStackView()
    
    let fullNameLabel = UILabel()
    let jobTitleLabel = UILabel()
    let departmentLabel = UILabel()
    let locationLabel = UILabel()
    let logOutButton = UIButton()
    
    var presenter: ProfilePresenter
    
    public init(userUID:String) {
        presenter = ProfilePresenter(userUID: userUID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.delegate = self
        setupScrollView()
        setupLabels()
        setupButton()
        presenter.viewDidLoad()
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
         self.logOutButton,
        ].forEach {contentStackView.addArrangedSubview($0)}
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
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
        
    }
    
    func setupButton() {

        logOutButton.configuration = .filled()
        logOutButton.configuration?.baseBackgroundColor = .systemRed
        logOutButton.configuration?.title = "Log Out"
        logOutButton.configuration?.baseForegroundColor = .black
        
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
    
        
    }
    
    @objc func handleLogOut() {
        presenter.logOut()
    }
    
    func reloadView(user: User) {
        fullNameLabel.text = user.name
        jobTitleLabel.text = user.jobTitle
        departmentLabel.text = user.department
        locationLabel.text = user.location
    }
    
    func reloadViewWithError(error: FirebaseError) {
        fullNameLabel.text = "Not Found"
        jobTitleLabel.text = "Not Found"
        departmentLabel.text = "Not Found"
        locationLabel.text = "Not Found"
    }
    
    func presentError(error: FirebaseError) {
        let alertController = UIAlertController(title: "FAILED TO LOG OUT", message: "Uh Oh Firebase went poopy", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
        present(alertController, animated: true)
    }
}
