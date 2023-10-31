//
//  HorizontalStackViews.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class HorizontalStackView: UIStackView {

    private var heroThumbnailViews = [HeroThumbnailView(), HeroThumbnailView(),
                              HeroThumbnailView(), HeroThumbnailView()]

    func transferThumbnailData(data: [(String, String)]) {

        setupViews()
        setupConstraints()

        self.setRulesStackView(backgroundColor: .white, axis: .horizontal, distribution: .fillEqually,
                               alignment: .fill, spacing: 2)

        //Shows 4 hero views per Horizontal
        var auxData = data
        for heroThumbnailView in heroThumbnailViews {

            heroThumbnailView.transferData(tuple: auxData.removeFirst())
        }
    }

    func transferDetailData(data: Character) {

    }

    func setupViews() {

        for heroThumbnailView in heroThumbnailViews {

            self.addArrangedSubview(heroThumbnailView)
        }
    }

    func setupConstraints() {

        let heroThumbnailViewWidth = (UIScreen.main.bounds.width / 4) - 5

        for heroThumbnailView in heroThumbnailViews {

            heroThumbnailView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                heroThumbnailView.widthAnchor.constraint(equalToConstant: heroThumbnailViewWidth),
                heroThumbnailView.heightAnchor.constraint(equalToConstant: 170)
            ])
        }
    }
}

extension HorizontalStackView {

    func setupThumbnailViews() {

        for heroThumbnailView in heroThumbnailViews {

            self.addArrangedSubview(heroThumbnailView)
        }
    }

    func setupDetailViews() {


    }

    func setupThumbnailConstraints() {

        let heroThumbnailViewWidth = (UIScreen.main.bounds.width / 4) - 5

        for heroThumbnailView in heroThumbnailViews {

            heroThumbnailView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                heroThumbnailView.widthAnchor.constraint(equalToConstant: heroThumbnailViewWidth),
                heroThumbnailView.heightAnchor.constraint(equalToConstant: 170)
            ])
        }

    }

    func setupDetailConstraints() {



    }
}
