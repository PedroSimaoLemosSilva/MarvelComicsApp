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

    private let loadingScreen = IndicatorView()

    private let loadingMore = IndicatorView()

    private let loadButton = UIButton()

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {

            self.view.backgroundColor = .white

            configureLoadingView()
            loadingScreen.showSpinner()

            await mainViewModel.dataLoad()

            loadingScreen.hideSpinner()

            tableView.reloadData()
            addTableView()
            defineTableViewConstraints()
            configureTableView()
            configureTableViewFooter()

            let favouriteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.sendFavouriteCharacters))
            self.navigationItem.rightBarButtonItem = favouriteBarButtonItem

            navigationItem.title = "Marvel Comics"


            tableView.register(CharacterThumbnailCell.self, forCellReuseIdentifier: "TableViewCell")
        }
    }
}

private extension MainViewController {

    func configureLoadingView() {

        loadingScreen.setupViews()
        loadingScreen.setupConstraints()

        self.view.addSubview(self.loadingScreen)

        self.loadingScreen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.loadingScreen.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.loadingScreen.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.loadingScreen.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingScreen.topAnchor.constraint(equalTo: self.view.topAnchor)
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

        loadingMore.setupViews()
        loadingMore.setupConstraints()

        loadingMore.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 100)

        loadingMore.backgroundColor = .clear

        loadButton.frame = CGRect(x: 30, y: 30, width: self.view.frame.width - 60, height: 40)
        loadButton.backgroundColor = .systemGray
        loadButton.isUserInteractionEnabled = true
        loadButton.setTitle("Load More", for: .normal)
        loadButton.addTarget(self, action: #selector(self.dataLoadMore), for: .touchUpInside)

        loadingMore.addSubview(loadButton)
        self.tableView.tableFooterView = loadingMore

    }

    @objc
    func dataLoadMore() {

        Task {

            loadButton.isHidden = true
            loadingMore.showSpinner()
            await mainViewModel.dataLoad()
            loadButton.isHidden = false
            loadingMore.hideSpinner()
            tableView.reloadData()
        }
    }

    @objc
    func sendFavouriteCharacters() {

        self.tableView.reloadData()
    }
}

extension MainViewController: DetailsViewControllerDelegate {

    func sendFavouriteSelected(id: Int ,favourite: Bool) {
        
        mainViewModel.changeFavourite(id: id ,favourite: favourite)

        self.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let numberOfRows = mainViewModel.numberOfRows() {

            return numberOfRows
        } else {

            return 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? CharacterThumbnailCell else {

            return UITableViewCell()
        }

        cell.selectionStyle = .none

        let heartIcon = UIImageView(frame: CGRectMake(0, 0, 15, 15))
        cell.accessoryView = heartIcon

        guard let (id, name, image, favourite) = mainViewModel.characterForRowAt(indexPath: indexPath) else { return UITableViewCell() }
        cell.transferThumbnailData(id: id, name: name, image: image)

        if favourite {

            heartIcon.image = UIImage(named: "icons8-heart-50 (1).png")
        } else {

            heartIcon.image = UIImage(named: "icons8-heart-50.png")
        }

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

        guard let item = mainViewModel.characterForRowAt(indexPath: indexPath) else {

            return
        }

        let detailsViewController = DetailsViewController(id: item.0, name: item.1, image: item.2, favourite: item.3)
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: false)
    }
}



