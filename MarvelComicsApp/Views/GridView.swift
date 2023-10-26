//
//  GridView.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class GridView: UIStackView {

    var rowStackView: [RowStackView] = []

    func addRowStackView(childView view: RowStackView) {

        self.addArrangedSubview(view)
        self.rowStackView.append(view)
    }

    func populateGrid(parentView view: UIScrollView) {

        view.addSubview(self)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        self.setRulesStackView(backgroundColor: .purple, axis: .vertical, distribution: .fillEqually,
                               alignment: .fill, spacing: 1)

        //Shows 5 row until theres a need to lead more
        for i in 0...5 {

            self.addRowStackView(childView: RowStackView())

            rowStackView[i].populateRowStackView(parentView: self)
        }


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
