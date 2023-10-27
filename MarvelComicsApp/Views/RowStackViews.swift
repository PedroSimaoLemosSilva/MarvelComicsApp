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

    func populateRowStackView(parentView view: UIStackView, characterDictionary dict: [String: String]) {

        view.addArrangedSubview(self)

        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        self.setRulesStackView(backgroundColor: .white, axis: .horizontal, distribution: .fillEqually,
                               alignment: .fill, spacing: 2)

        //Shows 4 hero views per row
        var newDict = dict
        for i in 0...3 {

            self.addHeroView(heroView: HeroView())

            var (charName, charThumbnail): (String, String?) = ("", "")

            var j = 1
            for (charactersName, _) in newDict {

                if j == 1 {

                    (charName, charThumbnail) = (charactersName, newDict.removeValue(forKey: charactersName))
                }
                j -= 1
            }

            //print((charName, charThumbnail))
            heroViews[i].populateHeroView(parentView: self, tuple: (charName, charThumbnail))
        }
    }
}
