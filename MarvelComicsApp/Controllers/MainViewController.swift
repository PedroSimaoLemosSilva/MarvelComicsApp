//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit
class MainViewController: UIViewController {

    private let mainViewModel = MainViewModel()

    private let tableView = UITableView()

    private let footerView = UIView()

    private let indicatorView = IndicatorView()

    private let loadIndicator = UIActivityIndicatorView()

    private let loadButton = UIButton()

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {

            self.view.backgroundColor = .white

            configureLoadingView()
            indicatorView.showSpinner()

            await mainViewModel.dataLoad()

            indicatorView.hideSpinner()

            tableView.reloadData()
            addTableView()
            defineTableViewConstraints()
            configureTableView()
            configureTableViewFooter()

            navigationItem.title = "Marvel Comics"

            tableView.register(CharacterThumbnailCell.self, forCellReuseIdentifier: "TableViewCell")
        }
    }
}

private extension MainViewController {

    func configureLoadingView() {

        indicatorView.setupViews()
        indicatorView.setupConstraints()

        self.view.addSubview(self.indicatorView)

        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.indicatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.indicatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.indicatorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.indicatorView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }

    func addTableView() {

        self.view.addSubview(self.tableView)
    }

    func defineTableViewConstraints() {

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func configureTableView() {

        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }

    func configureTableViewFooter() {

        footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 100)
        loadIndicator.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 100)

        footerView.backgroundColor = .clear

        loadButton.frame = CGRect(x: 30, y: 30, width: self.view.frame.width - 60, height: 40)
        loadButton.backgroundColor = .systemGray
        loadButton.isUserInteractionEnabled = true
        loadButton.setTitle("Load More", for: .normal)
        loadButton.addTarget(self, action: #selector(self.dataLoadMore), for: .touchUpInside)

        footerView.addSubview(loadIndicator)
        footerView.addSubview(loadButton)
        self.tableView.tableFooterView = footerView

    }

    private func showSpinner() {

        loadButton.isHidden = true
        loadIndicator.startAnimating()
        loadIndicator.isHidden = false
    }

    private func hideSpinner() {

        loadButton.isHidden = false
        loadIndicator.stopAnimating()
        loadIndicator.isHidden = true

    }

    @objc
    func dataLoadMore() {

        Task {

            self.showSpinner()
            await mainViewModel.dataLoad()
            self.hideSpinner()
            tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mainViewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? CharacterThumbnailCell else {

            return UITableViewCell()
        }

        cell.selectionStyle = .none

        let item = mainViewModel.characterForRowAt(indexPath: indexPath)
        cell.transferThumbnailData(id: item.id, name: item.name, imageData: item.imageData)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 5
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = mainViewModel.characterForRowAt(indexPath: indexPath)

        let detailsViewController = DetailsViewController(characterThumbnail: item)
        navigationController?.pushViewController(detailsViewController, animated: false)
    }
}



