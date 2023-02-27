//
//  WeeklyView.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 22/02/2023.
//

import UIKit

protocol WeeklyViewDelegate {
    func dateButtonClicked (index: Int)
    func forwardWeekButtonClicked ()
    func backwardWeekButtonClicked ()
}


class WeeklyView: UIView {
    
    let weeklyStackView = UIStackView()
    let delegate: WeeklyViewDelegate
    var buttonArray:[UIButton] = []
    let daysStackView = UIStackView()
    let monthLabel = UILabel()
    let rightArrowButton:UIButton
    let leftArrowButton:UIButton
    
    
    
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
    
    
    
    public init (delegate:WeeklyViewDelegate) {
        //delegate initializer
        self.delegate = delegate
        //arrow button initializer
        leftArrowButton = UIButton(configuration: .plain(), primaryAction: UIAction(handler: { action in
            delegate.backwardWeekButtonClicked()
        }))
        rightArrowButton = UIButton(configuration: .plain(), primaryAction: UIAction(handler: { action in
            delegate.forwardWeekButtonClicked()
        }))
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        
        //Month Label
        addSubview(monthLabel)
        
        monthLabel.text = "February 2023"
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
        
        //Days of Month
        
        addSubview(daysStackView)
        
        daysStackView.axis = .horizontal
        daysStackView.spacing = 10.0
        daysStackView.alignment = .fill
        daysStackView.distribution = .fillEqually
        
        let sundayLabel: UILabel = {
            let day = UILabel()
            day.text = "Sun"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()

        let mondayLabel: UILabel = {
            let day = UILabel()
            day.text = "Mon"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()
        
        let tuesdayLabel: UILabel = {
            let day = UILabel()
            day.text = "Tue"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()
        
        let wednesdayLabel: UILabel = {
            let day = UILabel()
            day.text = "Wed"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()
        
        let thursdayLabel: UILabel = {
            let day = UILabel()
            day.text = "Thu"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()
        
        let fridayLabel: UILabel = {
            let day = UILabel()
            day.text = "Fri"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()
        
        let saturdayLabel: UILabel = {
            let day = UILabel()
            day.text = "Sat"
            day.font = UIFont.boldSystemFont(ofSize: 20)
            day.textAlignment = .center
            return day
        }()
        
        [sundayLabel,
         mondayLabel,
         tuesdayLabel,
         wednesdayLabel,
         thursdayLabel,
         fridayLabel,
         saturdayLabel,
        ].forEach {daysStackView.addArrangedSubview($0)}
        
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
                delegate.dateButtonClicked(index: position)
            }))
            weeklyStackView.addArrangedSubview(button)
            button.configuration?.baseBackgroundColor = .blue
            buttonArray.append(button)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDateSelection (index: Int, selected: Bool) {
        let backgroundColour: UIColor = selected ? .red : .blue
        buttonArray[index].configuration?.baseBackgroundColor = backgroundColour
    }
    
    func updateMonthLabel (month:String) {
        monthLabel.text = month
    }
    
    func setWeekView(withDates:[Date]) {
        buttonArray.enumerated().forEach { index, button in
            button.configuration?.title = String(describing:WeeklyCalendarHelper().dayOfMonth(date: withDates[index]))
        }
    }
    


}
