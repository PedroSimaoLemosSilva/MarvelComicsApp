//
//  FavouritesViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 16/11/2023.
//

import UIKit

class FavouritesViewController: UIViewController {

    var delegate: FavouritesViewControllerDelegate?

    private let favouritesViewModel = FavouritesViewModel()

    private let tableView = UITableView()

    private let loadingScreen = IndicatorView()

    init(favouriteThumbnails: [CharacterThumbnail], favouritesId: [Int]) {

        super.init(nibName: nil, bundle: nil)

        favouritesViewModel.setCharacterThumbnails(characterThumbnails: favouriteThumbnails)

        favouritesViewModel.favouritesId = favouritesId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            
            self.view.backgroundColor = .white
            
            configureLoadingView()
            loadingScreen.showSpinner()
            tableView.isHidden = true
            
            favouritesViewModel.checkFavouriteInList()
            await favouritesViewModel.dataLoad()

            tableView.isHidden = false
            loadingScreen.hideSpinner()
            
            tableView.reloadData()
            addTableView()
            defineTableViewConstraints()
            configureTableView()
            
            navigationItem.title = "Favourites"
            
            tableView.register(CharacterThumbnailCell.self, forCellReuseIdentifier: "TableViewCell")
        }
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
}

extension FavouritesViewController: DetailsViewControllerDelegate {

    func sendFavouriteSelected(id: Int, favourite: Bool) {

        favouritesViewModel.changeFavourite(id: id ,favourite: favourite)
        favouritesViewModel.saveChanges()

        self.tableView.reloadData()

        delegate?.sendFavouriteToMain(id: id,favourite: favourite)
    }
}

extension FavouritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let numberOfRows = favouritesViewModel.numberOfRows() {

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

        guard let (id, name, image, _) = favouritesViewModel.characterForRowAt(indexPath: indexPath) else { return

            UITableViewCell()
        }
        cell.transferThumbnailData(id: id, name: name, image: image)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 5
    }
}

extension FavouritesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let item = favouritesViewModel.characterForRowAt(indexPath: indexPath) else {

            return
        }

        let detailsViewController = DetailsViewController(id: item.0, name: item.1, image: item.2, favourite: item.3)
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: false)
    }
}

protocol FavouritesViewControllerDelegate {

    func sendFavouriteToMain(id: Int, favourite: Bool)
}
