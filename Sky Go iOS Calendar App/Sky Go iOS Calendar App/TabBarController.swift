//
//  TabBarController.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 17/02/2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Designing Tabbar Item Images
        let calendar = UITabBarItem(title: "Calendar", image:UIImage(systemName: "calendar.badge.plus") , tag: 0)
        let officeDays = UITabBarItem(title: "Office Days", image: UIImage(systemName: "list.dash"), tag: 1)

        //Getting TabBar ViewControllers
        let calendarVC =  HomeViewController()
        calendarVC.title = "Calendar"
        
        let officeDaysVC = OfficeDaysViewController()
        officeDaysVC.title = "Office Days"
        
        calendarVC.tabBarItem = calendar
        officeDaysVC.tabBarItem = officeDays
        
        
        let controllers = [calendarVC, officeDaysVC]
        self.viewControllers = controllers.map{UINavigationController(rootViewController: $0)}
        self.tabBar.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.
    }
    

}
