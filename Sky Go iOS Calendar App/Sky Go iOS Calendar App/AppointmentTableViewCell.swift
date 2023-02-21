//
//  AppointmentTableViewCell.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 20/02/2023.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContainerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.font = UIFont.boldSystemFont(ofSize: 20)
        date.textColor = .black
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    let locationLabel:UILabel = {
        let location = UILabel()
        location.font = UIFont.boldSystemFont(ofSize: 14)
        location.textColor = .white
        location.backgroundColor = .orange
        location.layer.cornerRadius = 5
        location.clipsToBounds = true
        location.translatesAutoresizingMaskIntoConstraints = false
        return location
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    func setupContainerView() {
        self.contentView.addSubview(containerView)
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    var appointment:Appointment? {
        didSet{
            guard let appointmentItem = appointment else {return}
            if let date = appointmentItem.date {
                dateLabel.text = date
            }
            if let location = appointmentItem.location {
                locationLabel.text = location
            }
        }
    }
    
}
