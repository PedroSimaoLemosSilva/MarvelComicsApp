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
    
    private let searchBar = UISearchBar()

    var searchTimer: Timer? = Timer()

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {

            self.view.backgroundColor = .white
            
            configureSearchBar()
            configureBarButtons()
           
            configureLoadingView()
            loadingScreen.showSpinner()

            await mainViewModel.dataLoad()
            mainViewModel.loadAllFavourites()

            loadingScreen.hideSpinner()
            self.searchBar.isEnabled = true
            tableView.reloadData()

            addTableView()
            defineTableViewConstraints()
            configureTableView()
            configureTableViewFooter()

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
        self.tableView.separatorStyle = .singleLine
    }

    func configureTableViewFooter() {

        loadingMore.setupViews()
        loadingMore.setupConstraints()

        loadingMore.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 100)

        loadingMore.backgroundColor = .clear
        
        self.tableView.tableFooterView = loadingMore

    }

    func configureBarButtons() {

        let favouriteBarButtonItem = UIBarButtonItem(image: UIImage(named: "icons8-heart-50 (1).png"), style: .plain, target: self, action: #selector(self.changeToFavouritesViewController))
        self.navigationItem.rightBarButtonItem = favouriteBarButtonItem
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(self.exitSearchTable))
        //self.navigationItem.leftBarButtonItem?.isEnabled = false
    }

    func dataLoadMore() {

        Task {

            self.searchBar.isEnabled = false
            loadingMore.showSpinner()
                
            await mainViewModel.dataLoad()
            mainViewModel.setAllFavourites()
            
            loadingMore.hideSpinner()
            self.searchBar.isEnabled = true
            tableView.reloadData()
        }
    }

    func dataLoadMoreSearch() {
        
        Task {

            loadingMore.showSpinner()
                
            await mainViewModel.dataLoadSearch()
            mainViewModel.setAllFavourites()
            
            loadingMore.hideSpinner()
            tableView.reloadData()
        }
    }
    
    @objc
    func sendFavouriteCharacters() {

        self.tableView.reloadData()
    }

    @objc
    func changeToFavouritesViewController() {

        let favouritesViewController = FavouritesViewController(favouriteThumbnails: mainViewModel.filterFavourites())
        favouritesViewController.delegate = self
        navigationController?.pushViewController(favouritesViewController, animated: false)
    }

    func exitSearchTable() {

        if self.mainViewModel.getState() {

            self.mainViewModel.changeState()
        }
        self.mainViewModel.setDoneLoadedSearch(doneLoadedSearch: false)
        self.mainViewModel.resetCharacterThumbnailsSearch()
        //self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.tableView.reloadData()
    }
}

extension MainViewController: DetailsViewControllerDelegate {

    func sendFavouriteSelected(id: Int) {

        mainViewModel.changeFavourite(id: id)
        mainViewModel.saveChanges()
        
        self.tableView.reloadData()
    }
}

extension MainViewController: FavouritesViewControllerDelegate {

    func sendFavouriteToMain(id: Int) {

        self.tableView.reloadData()
    }
}

extension MainViewController: CharacterThumbnailCellDelegate {

    func sendCharacterClickedMain(id: Int) {

        mainViewModel.changeFavourite(id: id)
        mainViewModel.saveChanges()
        tableView.reloadData()
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
        cell.delegate = self

        let (id, name, image, favourite) = mainViewModel.characterForRowAt(indexPath: indexPath)

        cell.transferThumbnailData(id: id, name: name, thumbnailImage: image, favourite: favourite)

        if indexPath.row == mainViewModel.characterThumbnails.count - 1 && mainViewModel.getState() == false && mainViewModel.getDoneLoaded() == false {
            
            self.dataLoadMore()
        }
        
        if indexPath.row == mainViewModel.characterThumbnailsSearch.count - 1 && mainViewModel.getState() && mainViewModel.getDoneLoadedSearch() == false {

            self.dataLoadMoreSearch()
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

        let item = mainViewModel.characterForRowAt(indexPath: indexPath)

        let detailsViewController = DetailsViewController(id: item.0, name: item.1, image: item.2, favourite: item.3)
        detailsViewController.delegate = self
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func configureSearchBar() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.titleView = searchBar
        self.searchBar.isEnabled = false
        searchBar.delegate = self
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        exitSearchTable()
        searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if let task = self.mainViewModel.task {

            task.cancel()
            self.mainViewModel.task = nil
        }

        self.mainViewModel.task = Task {

            self.searchTimer?.invalidate()
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.searchBar.endEditing(true)
            loadingScreen.showSpinner()
            self.tableView.isHidden = true
            if self.mainViewModel.getState() == false {

                self.mainViewModel.changeState()
            }
            if let text = searchBar.text {

                self.mainViewModel.resetCharacterThumbnailsSearch()
                self.mainViewModel.setText(text: text)
                await self.mainViewModel.dataLoadSearch()
                self.mainViewModel.setAllFavourites()
            }
            
            loadingScreen.hideSpinner()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.searchTimer?.invalidate()
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        searchTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.main.async { [weak self] in


                if self?.mainViewModel.getState() == false {

                    self?.mainViewModel.changeState()
                }

                if let task = self?.mainViewModel.task {

                    task.cancel()
                    self?.mainViewModel.task = nil
                }

                self?.mainViewModel.task = Task {

                    self?.mainViewModel.resetCharacterThumbnailsSearch()
                    self?.mainViewModel.setText(text: searchText)
                    await self?.mainViewModel.dataLoadSearch()
                    
                    self?.mainViewModel.setAllFavourites()
                    self?.tableView.reloadData()
                }
            }
        })
    }
}

