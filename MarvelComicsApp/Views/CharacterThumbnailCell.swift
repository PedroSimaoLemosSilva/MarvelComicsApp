//
//  CharacterThumbnailCell.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import UIKit

class CharacterThumbnailCell: UITableViewCell {

    var delegate: CharacterThumbnailCellDelegate?

    private var id: Int = 0

    private let image = UIImageView()

    private let label = UILabel()

    fileprivate let heart = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func transferThumbnailData(id: Int, name: String, thumbnailImage: UIImage, heartImage: UIImage) {

        self.setupViews()
        self.setupConstraints()

        self.id = id
        self.label.text = name
        self.image.image = thumbnailImage
        self.heart.image = heartImage

        let tap = UITapGestureRecognizer(target: self, action: #selector(heartClicked))
        heart.addGestureRecognizer(tap)
        heart.isUserInteractionEnabled = true
    }
}

extension CharacterThumbnailCell {

    func setupViews() {

        self.backgroundColor = .white
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill

        label.backgroundColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        heart.backgroundColor = .white

        self.addSubview(image)
        self.addSubview(label)
        self.addSubview(heart)
    }

    func setupConstraints() {

        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.widthAnchor.constraint(equalToConstant: 150),
            image.heightAnchor.constraint(equalToConstant: 100)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.widthAnchor.constraint(equalToConstant: 210),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])

        heart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heart.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            heart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            heart.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            heart.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
        ])
    }

    @objc
    func heartClicked() {

        delegate?.sendCharacterClickedMain(id: self.id)
    }
}

protocol CharacterThumbnailCellDelegate {

    func sendCharacterClickedMain(id: Int)
}
