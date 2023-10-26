//
//  RowStackViews.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class RowStackView: UIStackView {

    var heroViews: [HeroView] = []

    func addHeroView(heroView view: HeroView) {

        self.addArrangedSubview(view)
        self.heroViews.append(view)
    }

    func populateRowStackView(parentView view: UIStackView) {

        view.addArrangedSubview(self)

        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        self.setRulesStackView(backgroundColor: .magenta, axis: .horizontal, distribution: .fillEqually,
                               alignment: .fill, spacing: 5)

        //Shows 4 hero views per row
        for i in 0...3 {

            self.addHeroView(heroView: HeroView())

            heroViews[i].populateHeroView(parentView: self)
        }
    }
}
