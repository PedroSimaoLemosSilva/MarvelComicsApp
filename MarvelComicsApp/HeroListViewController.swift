//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit

class HeroListViewController: UIViewController {

    let scrollView = UIScrollView()
    let heroView = HeroView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        scrollView.backgroundColor = .red

        heroView.setupHeroView(parentView: scrollView)

    }


}


