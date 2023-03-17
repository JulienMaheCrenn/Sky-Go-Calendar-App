//
//  TabBarController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 17/02/2023.
//

import UIKit
import FirebaseDatabase

class TabBarController: UITabBarController {
    
    private let userUID:String
    private let database:DatabaseReferenceProtocol
    private let user:User
    
    public init (userUID:String, database: DatabaseReferenceProtocol, user:User) {
        self.userUID = userUID
        self.database = database
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Designing Tabbar Item Images
        let calendar = UITabBarItem(title: "Calendar", image:UIImage(systemName: "calendar.badge.plus") , tag: 0)
        let officeDays = UITabBarItem(title: "Office Days", image: UIImage(systemName: "list.dash"), tag: 1)

        //Getting TabBar ViewControllers
        let calendarVC =  CalendarViewController(userUID: userUID, database: database, user:user)
        calendarVC.title = "Calendar"
        
        let officeDaysVC = OfficeDaysViewController()
        officeDaysVC.title = "Office Days"
        
        calendarVC.tabBarItem = calendar
        officeDaysVC.tabBarItem = officeDays
        
        
        let controllers = [calendarVC, officeDaysVC]
        self.viewControllers = controllers.map{
            let navigationController = UINavigationController(rootViewController: $0)
            let profileImage = UIImage(systemName: "person.circle")
            
            $0.navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(handleShowProfile))
            
            return navigationController
        }
        self.tabBar.backgroundColor = .systemGray6
        


        // Do any additional setup after loading the view.
    }
    @objc func handleShowProfile () {
        let profileView = ProfileViewController(userUID: userUID)
        present(profileView, animated: true)
    }

}
