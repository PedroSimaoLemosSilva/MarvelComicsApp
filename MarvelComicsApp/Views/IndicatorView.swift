//
//  IndicatorView.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 08/11/2023.
//

import UIKit

class IndicatorView: UIView {

    private let loadIndicator = UIActivityIndicatorView()
}

extension IndicatorView {

    func setupViews() {

        self.backgroundColor = .white

        loadIndicator.frame = CGRect(x: 0, y: 0, width: self.frame.width , height: 100)

        self.addSubview(loadIndicator)
    }

    func setupConstraints() {

        loadIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadIndicator.widthAnchor.constraint(equalToConstant: 100),
            loadIndicator.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func showSpinner() {

        loadIndicator.isHidden = false
        loadIndicator.startAnimating()
    }

    func hideSpinner() {

        loadIndicator.stopAnimating()
        loadIndicator.isHidden = true
    }
}
