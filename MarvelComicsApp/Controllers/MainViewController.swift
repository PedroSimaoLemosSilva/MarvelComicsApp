//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit

class MainViewController: UIViewController {

    let scrollView = UIScrollView()

    lazy var gridView = VerticalStackView()

    lazy var data: [[(String, String)]] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        setupViews()
        setupConstraints()

        navigationItem.title = "Marvel Comics"

        Task {

            do {
                
                data = try await Webservice().fetchCharactersNameThumbnailPath(url: Constants.Urls.characters)

                gridView.transferThumbnailData(data: self.data)
            } catch {
                
                print(error)
            }
        }

    }

    // Segue action - pushing to the new view
    @objc
    func buttonAction() {
        
        let detailsViewController = DetailsViewController()
        navigationController?.pushViewController(detailsViewController, animated: false)
    }

    func setupViews() {

        scrollView.backgroundColor = .white
        scrollView.addSubview(gridView)

        view.backgroundColor = .white
        view.addSubview(self.scrollView)
    }

    func setupConstraints() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        gridView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            gridView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            gridView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
}


