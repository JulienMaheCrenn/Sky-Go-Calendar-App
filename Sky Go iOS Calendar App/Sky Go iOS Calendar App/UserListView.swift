//
//  UserListView.swift
//  Sky Go iOS Calendar App
//
//  Created by Julien Mahe-Crenn on 27/02/2023.
//

import UIKit



class UserListView: UIView, UITableViewDataSource, UITableViewDelegate {


    let userTableView = UITableView()
    let usersArray: [User] = []

    public init () {
        super.init(frame: .zero)

        backgroundColor = .systemRed

        //TableView
        addSubview(userTableView)

        userTableView.dataSource = self
        userTableView.delegate = self

        userTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")

        userTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userTableView.topAnchor.constraint(equalTo: topAnchor),
            userTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            userTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {fatalError("Uh OH")}
        cell.user = usersArray[indexPath.row]
        return cell
    }

}


