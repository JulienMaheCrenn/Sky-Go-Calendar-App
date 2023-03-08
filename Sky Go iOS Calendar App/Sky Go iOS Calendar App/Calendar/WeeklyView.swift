//
//  WeeklyView.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 22/02/2023.
//

import UIKit

protocol WeeklyViewDelegate: AnyObject {
    func forwardWeekButtonClicked()
    func backwardWeekButtonClicked()
    func dateButtonClicked(index: Int)
}


class WeeklyView: UIView {
    
    let weeklyStackView = UIStackView()
    weak var delegate:WeeklyViewDelegate?
    var buttonArray:[UIButton] = []
    let daysStackView = UIStackView()
    let monthLabel = UILabel()
    let rightArrowButton = UIButton(configuration: .plain())
    let leftArrowButton = UIButton(configuration: .plain())
    
    
    
    func setupWeeklyStackView() {
        addSubview(weeklyStackView)
        
        weeklyStackView.axis = .horizontal
        weeklyStackView.spacing = 10.0
        weeklyStackView.alignment = .fill
        weeklyStackView.distribution = .fillEqually
        
        
        
        weeklyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weeklyStackView.topAnchor.constraint(equalTo: daysStackView.bottomAnchor, constant: 10),
            weeklyStackView.heightAnchor.constraint(equalToConstant: 50),
            weeklyStackView.widthAnchor.constraint(equalTo: widthAnchor),
            weeklyStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    
    
    public init () {
        
        super.init(frame: .zero)
        leftArrowButton.addTarget(self, action: #selector(backwardButtonClicked), for: .touchUpInside)
        rightArrowButton.addTarget(self, action: #selector(forwardButtonClicked), for: .touchUpInside)

        backgroundColor = .systemBackground
        
        //Month Label
        addSubview(monthLabel)
        
        monthLabel.text = "No Date Selected"
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            monthLabel.widthAnchor.constraint(equalToConstant: 200),
            monthLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        //Arrow Buttons
        

        addSubview(leftArrowButton)
        addSubview(rightArrowButton)
        let leftArrowImage = UIImage(systemName: "arrow.left")
        let rightArrowImage = UIImage(systemName: "arrow.right")
        
        leftArrowButton.configuration?.background.image = leftArrowImage
        rightArrowButton.configuration?.background.image = rightArrowImage
        
        
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftArrowButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            leftArrowButton.heightAnchor.constraint(equalTo: monthLabel.heightAnchor),
            leftArrowButton.widthAnchor.constraint(equalTo: monthLabel.heightAnchor),
            leftArrowButton.trailingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            
            rightArrowButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
            rightArrowButton.heightAnchor.constraint(equalTo: monthLabel.heightAnchor),
            rightArrowButton.widthAnchor.constraint(equalTo: monthLabel.heightAnchor),
            rightArrowButton.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor),
            
        ])
        
        //Days of the Week
        
        addSubview(daysStackView)
        
        daysStackView.axis = .horizontal
        daysStackView.spacing = 10.0
        daysStackView.alignment = .fill
        daysStackView.distribution = .fillEqually
        
        (0..<7).forEach { position in
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            
            if  (position == 0) {
                label.text = "Sun"
            }else if (position == 1) {
                label.text = "Mon"
            }else if (position == 2) {
                label.text = "Tue"
            }else if (position == 3) {
                label.text = "Wed"
            }else if (position == 4) {
                label.text = "Thu"
            }else if (position == 5) {
                label.text = "Fri"
            }else if (position == 6) {
                label.text = "Sat"
            }
            
            daysStackView.addArrangedSubview(label)
            
        }
        
        daysStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysStackView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10),
            daysStackView.heightAnchor.constraint(equalToConstant: 30),
            daysStackView.widthAnchor.constraint(equalTo: widthAnchor),
            daysStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        //Weekly CollectionView
        setupWeeklyStackView()
        
        (0..<7).forEach { position in
            let button = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { action in
                self.delegate?.dateButtonClicked(index: position)
            }))
            weeklyStackView.addArrangedSubview(button)
            button.configuration?.baseBackgroundColor = .blue
            buttonArray.append(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backwardButtonClicked() {
        delegate?.backwardWeekButtonClicked()
    }
    
    @objc func forwardButtonClicked() {
        delegate?.forwardWeekButtonClicked()
    }

}
