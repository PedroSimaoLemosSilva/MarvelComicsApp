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

        Task {
            do {

                let i = try await Webservice().fetchCharacterDataWrapper(url: Constants.Urls.characters)
            } catch {

                print(error)
            }
        }
    }
}


