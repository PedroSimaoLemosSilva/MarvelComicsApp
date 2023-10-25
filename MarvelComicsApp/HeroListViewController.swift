//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit

class HeroListViewController: UIViewController {

    let scrollView = UIScrollView()
    let safeView = UIView()
    //let stackView = UIStackView()

    //let heroesView1 = HeroesView()
    //let heroesView2 = HeroesView()
    //let heroesView3 = HeroesView()

    let gridView = GridView()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(self.scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        scrollView.backgroundColor = .red

        gridView.populateGrid(parentView: scrollView)

        view.addSubview(self.safeView)

        safeView.translatesAutoresizingMaskIntoConstraints = false
        safeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        safeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        safeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        safeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        safeView.backgroundColor = .brown

        /*
        scrollView.addSubview(stackView)

        stackView.setRulesStackView(backgroundColor: .magenta, axis: .vertical, distribution: .fillEqually, alignment: .fill, spacing: 0)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        heroesView1.setupHeroesRowView(parentView: stackView)
        heroesView2.setupHeroesRowView(parentView: stackView)
        heroesView3.setupHeroesRowView(parentView: stackView)
         */

    }


}


