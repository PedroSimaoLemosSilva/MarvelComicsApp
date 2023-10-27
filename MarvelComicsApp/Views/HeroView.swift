//
//  HeroView.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class HeroView: UIStackView {

    let imageView = UIImageView()

    let label = UILabel()

    func addChildren(imageView image: UIImageView, label: UILabel) {

        self.addArrangedSubview(image)
        self.addArrangedSubview(label)
    }

    func populateHeroView(parentView view: UIStackView, tuple: (String, String?)) {

        view.addArrangedSubview(self)

        let heroViewWidth = (UIScreen.main.bounds.width / 4) - 5

        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: heroViewWidth).isActive = true
        self.heightAnchor.constraint(equalToConstant: 170).isActive = true

        self.setRulesStackView(backgroundColor: .white, axis: .vertical, distribution: .fill,
                               alignment: .fill, spacing: 0)

        let (charName, charThumbnail) = tuple

        imageView.backgroundColor = .magenta
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        if let charThumbnail = charThumbnail {
            let u = charThumbnail + "/portrait_xlarge.jpg"
            //print(u)
            imageView.load(url: URL(string: u)!)
        }

        label.backgroundColor = .white
        label.text = charName
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        self.addChildren(imageView: imageView, label: label)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 140).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
