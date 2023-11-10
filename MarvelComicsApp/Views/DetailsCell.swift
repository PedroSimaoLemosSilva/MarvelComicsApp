//
//  DetailsCell.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 06/11/2023.
//

import UIKit

class DetailsCell: UITableViewCell {

    private let title = UILabel()

    private let textDescription = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func transferDetailsData(title: String, description: String) {

        self.setupViews()
        self.setupConstraints()

        self.title.text = title
        self.textDescription.text = description
    }
}

extension DetailsCell {

    func setupViews() {

        title.backgroundColor = .white
        title.textAlignment = .left
        title.adjustsFontSizeToFitWidth = true
        title.font = UIFont.boldSystemFont(ofSize: 20.0)

        textDescription.backgroundColor = .white
        textDescription.textAlignment = .left
        textDescription.numberOfLines = 0
        textDescription.adjustsFontSizeToFitWidth = true
        textDescription.font = UIFont.systemFont(ofSize: 14.0)

        self.addSubview(title)
        self.addSubview(textDescription)
    }

    func setupConstraints() {

        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.heightAnchor.constraint(equalToConstant: 50)
        ])

        textDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -7),
            textDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7),
            textDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textDescription.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2)
        ])
    }
}

