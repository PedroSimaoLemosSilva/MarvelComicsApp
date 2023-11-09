//
//  CharacterThumbnailCell.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import UIKit

class CharacterThumbnailCell: UITableViewCell {

    private var id: Int = 0

    private let image = UIImageView()

    private let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func transferThumbnailData(id: Int, name: String, imageData: Data) {

        self.setupViews()
        self.setupConstraints()

        self.id = id
        self.label.text = name
        self.image.load(data: imageData)
    }
}

extension CharacterThumbnailCell {

    func setupViews() {

        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill

        label.backgroundColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        self.addSubview(image)
        self.addSubview(label)
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
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        self.image.image = nil
    }
}

extension UIImageView {

    func load(data: Data) {

        DispatchQueue.global().async { [weak self] in

           if let image = UIImage(data: data) {

                DispatchQueue.main.async {

                    self?.image = image
                }
            }
        }
    }
}
