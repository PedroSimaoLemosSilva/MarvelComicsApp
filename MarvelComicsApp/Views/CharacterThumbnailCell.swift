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

    func transferThumbnailData(id: Int, name: String, imageUrl: String) {

        self.setupViews()
        self.setupConstraints()

        self.id = id
        self.label.text = name
        guard let url = URL(string: imageUrl) else { return }
        self.image.load(url: url)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CharacterThumbnailCell {

    func setupViews() {

        image.backgroundColor = .magenta
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
            image.widthAnchor.constraint(equalToConstant: 150)
            //image.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -100)
        ])

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10)
        ])
    }
}

extension UIImageView {

    func load(url: URL) {

        DispatchQueue.global().async { [weak self] in

            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {

                DispatchQueue.main.async {

                    self?.image = image
                }
            }
        }
    }
}
