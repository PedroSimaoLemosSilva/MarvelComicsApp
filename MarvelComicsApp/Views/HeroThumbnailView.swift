//
//  HeroView.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class HeroThumbnailView: UIButton {

    private let stackView = UIStackView()

    private let image = UIImageView()

    private let label = UILabel()

    func transferData(tuple: (String, String)) {

        setupViews()
        setupConstraints()
        setupClickable()

        let (charName, charThumbnail) = tuple
        //print((charName, charThumbnail))
        image.load(url: URL(string: charThumbnail)!)
        label.text = charName


    }

    func setupViews() {

        stackView.setRulesStackView(backgroundColor: .white, axis: .vertical,
                                    distribution: .fill, alignment: .fill, spacing: 0)

        //image.isUserInteractionEnabled = true
        image.backgroundColor = .magenta
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill

        //label.isUserInteractionEnabled = true
        label.backgroundColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        self.addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
    }

    func setupConstraints() {

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor)
        ])

        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 140).isActive = true

        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setupClickable() {

        var resp : UIResponder! = self
        while !(resp is MainViewController) { resp = resp.next }
        let vc = resp as! MainViewController

        let tapGesture = UITapGestureRecognizer(target: vc, action: #selector(vc.buttonAction))

        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
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
