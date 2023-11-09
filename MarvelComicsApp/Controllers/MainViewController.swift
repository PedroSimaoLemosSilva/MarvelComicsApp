//
//  ViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 24/10/2023.
//

import UIKit
class MainViewController: UIViewController {

    private let tableView = UITableView()

    private let webservice = MainWebservice()

    private let footerView = UIView()

    private let indicatorView = IndicatorView()

    private let loadIndicator = UIActivityIndicatorView()

    private let loadButton = UIButton()

    lazy var characterThumbnails: [CharacterThumbnail] = []

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {

            configureLoadingView()
            indicatorView.showSpinner()
            tableView.reloadData()
            await dataLoad()
            indicatorView.hideSpinner()
            addSubviews()
            defineSubviewConstraints()
            configureSubviews()
            configureFooterTableView()

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

    func addSubviews() {

        self.view.addSubview(self.tableView)
    }

    func defineSubviewConstraints() {

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func configureSubviews() {

        self.view.backgroundColor = .white

        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
    }

    func configureFooterTableView() {

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

    func dataLoad() async {

        do {

            guard let characterDataWrapper = try await webservice.fetchCharactersInfo(),
                  let charactersData = characterDataWrapper.data?.results else { return }

            for character in charactersData {

                guard let id = character.id,
                      let name = character.name,
                      let path = character.thumbnail?.path,
                      let ext = character.thumbnail?.extension0 else { return }

                let imageUrl = path + "." + ext

                let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl)

                let characterThumbnail = CharacterThumbnail(id: id, name: name, imageData: imageData)

                characterThumbnails.append(characterThumbnail)
            }
        } catch { print(error) }
    }

    @objc
    func dataLoadMore() {

        Task {

            self.showSpinner()
            await dataLoad()
            self.hideSpinner()
            tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.characterThumbnails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? CharacterThumbnailCell else {

            return UITableViewCell()
        }

        cell.selectionStyle = .none
        
        let item = characterThumbnails[indexPath.row]
        configureCell(for: cell, with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 5
    }

    func configureCell(for cell: CharacterThumbnailCell, with item: CharacterThumbnail) {

        cell.transferThumbnailData(id: item.id, name: item.name, imageData: item.imageData)
        
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = characterThumbnails[indexPath.row]

        let detailsViewController = DetailsViewController(characterThumbnail: item)
        navigationController?.pushViewController(detailsViewController, animated: false)
    }
}



