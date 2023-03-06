//
//  UserTableViewCell.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 27/02/2023.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let containerView = UIView()
    let nameLabel = UILabel()
    let jobTitleLabel = UILabel()
    let departmentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Profile Image
        self.contentView.addSubview(profileImageView)
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: "neutralProfileIcon")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        // Label Container view
        self.contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        
        // Name Label
        containerView.addSubview(nameLabel)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .systemBlue
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Job Title Label
        containerView.addSubview(jobTitleLabel)
        
        jobTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            jobTitleLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor),
            jobTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            jobTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Department Label
        containerView.addSubview(departmentLabel)
        
        departmentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        departmentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            departmentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            departmentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            departmentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var user:User? {
        didSet{
            guard let userItem = user else {return}
            nameLabel.text = userItem.name
            jobTitleLabel.text = userItem.jobTitle
            departmentLabel.text = userItem.department
        }
    }
}
