//
//  HeroView.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class HeroView: UIStackView {

    let imageView = UIImageView()

    let heroNameLabel = UILabel()

    func setupHeroView(parentView view: UIView) {

        view.addSubview(self)
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(heroNameLabel)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo:self.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: heroNameLabel.topAnchor, constant: -2).isActive = true
        imageView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true

        heroNameLabel.translatesAutoresizingMaskIntoConstraints = false
        heroNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        heroNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        heroNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        heroNameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3).isActive = true

        self.setRulesStackView(backgroundColor: .blue, axis: .vertical, distribution: .fill,
                                    alignment: .fill, spacing: 2)

        imageView.backgroundColor = .yellow

        heroNameLabel.backgroundColor = .orange
        heroNameLabel.text = "Iron Man"
        heroNameLabel.textAlignment = .center
    }


}

extension UIStackView {

    func setRulesStackView(backgroundColor: UIColor, axis: NSLayoutConstraint.Axis,
                           distribution: UIStackView.Distribution,
                           alignment: UIStackView.Alignment, spacing: CGFloat) {

        self.backgroundColor = backgroundColor
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}
