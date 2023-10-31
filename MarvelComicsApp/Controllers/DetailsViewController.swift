//
//  DetailsViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 31/10/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    let scrollView = UIScrollView()

    lazy var verticalView = VerticalStackView()

    override func viewDidLoad() {

        super.viewDidLoad()

        setupViews()
        setupConstraints()

        //verticalView.transferDetailData(data: nil)

        // Do any additional setup after loading the view.
    }

    func setupViews() {

        scrollView.backgroundColor = .white
        scrollView.addSubview(verticalView)

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

        verticalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            verticalView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            verticalView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
}
